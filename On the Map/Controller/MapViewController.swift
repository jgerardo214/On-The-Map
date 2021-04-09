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
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    
    
    @IBAction func addLocationPressed(_ sender: Any) {
        
        
        
       
        
        
        }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        
    }
    
    func showMapPinnedLocations(_ locations: [StudentLocation]) {
        
        
        
        
        
    }
    
    func handleStudentLocationsResponse(locations: [StudentLocation], error: Error?) {
        
        if error == nil {
            if self.mapView.annotations.count > 0 {
                mapView.removeAnnotation(self.mapView.annotations as! MKAnnotation)
            }
            showMapPinnedLocations(locations)
        }
        
        
        
    }
    
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    

    
}


