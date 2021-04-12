//
//  MapViewController.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 3/30/21.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    
    
    @IBAction func addLocationPressed(_ sender: Any) {
        
        let informationPostingVC = storyboard?.instantiateViewController(withIdentifier: "InformationPostingVC") as! InformationPostingVC
        present(informationPostingVC, animated: true, completion: nil)
        
        
        }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        refreshButton.isEnabled = false
        UdacityAPI.logout(completion: handleLogoutResponse(success:error:))
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func showMapPinnedLocations(_ locations: [StudentLocation]) {
        
        var pinnedLocation = [MKPointAnnotation]()
               
        for location in locations {
            let latitude = CLLocationDegrees(location.latitude!)
            let longitude = CLLocationDegrees(location.longitude!)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let firstName = location.firstName
            let lastName = location.lastName
            let mediaURL = location.mediaURL
            
            let pinnedLocations = MKPointAnnotation()
            pinnedLocations.coordinate = coordinate
            pinnedLocations.title = "\(firstName) \(lastName)"
            pinnedLocations.subtitle = mediaURL
            
            pinnedLocation.append(contentsOf: pinnedLocation)
        }
        
        self.mapView.addAnnotations(pinnedLocation)
        
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    func mappedLocations(_ locations: [StudentLocation]) {
        
        
        
        
    }
    
    func handleStudentLocationsResponse(locations: [StudentLocation], error: Error?) {
        refreshButton.isEnabled = true
        
        if error == nil {
            if self.mapView.annotations.count > 0 {
                self.mapView.removeAnnotations(self.mapView.annotations)
            }
            appDelegate.studentLocations = locations
            showMapPinnedLocations(locations)
        } else {
            showFailure(title: "Get Student Locations Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            showFailure(title: "Logout Failed", message: error?.localizedDescription ?? "")
        }
    }
    func showFailure(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    
}


