//
//  LocationFinalized.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 4/2/21.
//

import Foundation
import UIKit
import MapKit

class LocationFinalizedVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var mapString: String = ""
    var mediaURL: String = ""
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mapView.alpha = 0.0
        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
            self.mapView.alpha = 1.0
        })
    }
    

    
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        
        UdacityAPI.getUserData(completion: handleUserData(firstName:lastName:error:))
    }
   
    func handleUserData(firstName: String?, lastName: String?, error: Error?) {
        if error == nil {
            UdacityAPI.postStudentLocation(firstName: firstName!, lastName: lastName!, mapString: self.mapString, mediaURL: self.mediaURL, latitude: self.latitude, longitude: self.longitude, completion: handlePostStudentResponse(success:error:))
            
        }
    }
    
    func handlePostStudentResponse(success: Bool, error: Error?) {
        if success {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
}
    
}
