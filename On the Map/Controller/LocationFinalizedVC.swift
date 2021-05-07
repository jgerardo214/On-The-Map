//
//  LocationFinalized.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 4/2/21.
//

import Foundation
import UIKit
import MapKit

class LocationFinalizedVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var navbar: UINavigationItem!
    
    
    
    private var presentingController : UIViewController?
    
    var firstName: String = ""
    var lastName: String = ""
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var mapString: String = ""
    var mediaURL: String = ""
    var postLocationData: PostLocation?
 
    
    var locationRetrieved: String!
    var urlRetrieved: String!
    
    
    override func viewDidLoad() {
        mapView.delegate = self
        searchLocation()
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.dismiss(animated: true, completion: nil)
        UdacityAPI.getPublicUserData(completion: handlePublicUserData(firstName:lastName:error:))
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentingController = presentingViewController
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mapView.alpha = 0.0
        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
            self.mapView.alpha = 1.0
        })
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    

    
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        
        UdacityAPI.getPublicUserData(completion: handlePublicUserData(firstName:lastName:error:))
        
        UdacityAPI.postStudentLocation(firstName: firstName, lastName: lastName, mapString: self.locationRetrieved, mediaURL: self.urlRetrieved, latitude: latitude, longitude: longitude, completion: handlePostStudentResponse(success:error:))
    }
    
        
        
    
    func showMapAnnotation() {
        let latitude = CLLocationDegrees(self.latitude)
        let longitude = CLLocationDegrees(self.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = self.mapString

        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func searchLocation(){
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = locationRetrieved
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                guard let response = response else {
                    let alertVC = UIAlertController(title: "Location not found.", message: "Please input another location.", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.navigationController?.popViewController(animated: true)}))
                    self.present(alertVC, animated: true, completion: nil)
                    return
                }
                
                let pin = MKPointAnnotation()
                pin.coordinate = response.mapItems[0].placemark.coordinate
                pin.title = response.mapItems[0].name
                self.mapView.addAnnotation(pin)
                self.mapView.setCenter(pin.coordinate, animated: true)
                let region = MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                self.mapView.setRegion(region, animated: true)
            }
        }
    
    func handlePublicUserData(firstName: String?, lastName: String?, error: Error?) {
        if error == nil {
            
            UdacityAPI.postStudentLocation(firstName: firstName!, lastName: lastName!, mapString: self.locationRetrieved, mediaURL: self.urlRetrieved, latitude: self.latitude, longitude: self.longitude, completion: handlePostStudentResponse(success:error:))
            
        } else {
            showFailure(title: "There was an error!", message: error?.localizedDescription ?? "")
        }
    }
    
    func handlePostStudentResponse(success: Bool, error: Error?) {
        
        
     //let _: () =  UdacityAPI.postStudentLocation(firstName: firstName, lastName: lastName, mapString: self.locationRetrieved, mediaURL: self.urlRetrieved, latitude: latitude, longitude: longitude, completion: handlePostStudentResponse(success:error:))
        if success {
           let mainTabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapTableView")
           self.present(mainTabController, animated: true, completion: nil)
       } else {
          
           showFailure(title: "Unable to Save Information", message: error?.localizedDescription ?? "")
        }
    }
    
    func showFailure(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    


    
}
