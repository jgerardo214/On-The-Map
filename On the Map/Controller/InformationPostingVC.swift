//
//  InformationPostingVC.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 3/23/21.
//

import UIKit
import CoreLocation

class InformationPostingVC: UIViewController {
    
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    private var presentingController: UIViewController?
    var geocoder = CLGeocoder()
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    
    

    func showFailure(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func findLocationPressed(_ sender: Any) {
        if locationField.text!.isEmpty || linkField.text!.isEmpty {
            showFailure(title: "No information found!", message: "Please fill the missing location, link or information associated.")
            
            geocoder.geocodeAddressString(locationField.text ?? "") { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
    }
        
       
    
}
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if error != nil {
            showFailure(title: "Location Does Not Exist", message: "The informed location doesn't exist.")
        } else {
            if let placemarks = placemarks, placemarks.count > 0 {
                let location = (placemarks.first?.location)! as CLLocation

                let coordinate = location.coordinate
                self.latitude = Float(coordinate.latitude)
                self.longitude = Float(coordinate.longitude)
                                
                            
                goToConfirmingScreen()
            } else {
                showFailure(title: "Location Not Found!", message: "Try to specify full name (Ex: California, USA).")
            }
        }
    }
    
    func goToConfirmingScreen() {
        let informationConfirmingViewController = self.storyboard!.instantiateViewController(withIdentifier: "LocationFinalizedVC") as! LocationFinalizedVC
        informationConfirmingViewController.latitude = self.latitude
        informationConfirmingViewController.longitude = self.longitude
        informationConfirmingViewController.mapString = self.locationField.text!
        informationConfirmingViewController.mediaURL = self.linkField.text!
        informationConfirmingViewController.navigationItem.title = "LocationFinalized"
        self.navigationController?.pushViewController(informationConfirmingViewController, animated: true)
    }

}
