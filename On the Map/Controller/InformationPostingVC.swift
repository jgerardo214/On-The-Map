//
//  InformationPostingVC.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 3/23/21.
//

import UIKit
import CoreLocation

class InformationPostingVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var presentingController: UIViewController?
    var geocoder = CLGeocoder()
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var keyboardIsVisible = false
    var mediaUrl: String = ""
    var pinnedLocation: String!
    
    override func viewDidLoad() {
        locationField.delegate = self
        linkField.delegate = self
        self.activityIndicator.isHidden = true
        self.activityIndicator.hidesWhenStopped = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func findLocationPressed(_ sender: Any) {
        
        if locationField.text!.isEmpty {
            let alert = UIAlertController(title: "No Location", message: "No Location was entered", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            handleActivityIndicator(true)
            geocoder.geocodeAddressString(locationField.text ?? "") { placemarks, error in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
        }
        
        
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if error != nil {
            handleActivityIndicator(false)
            showFailure(title: "Location Do Not Exist", message: "The informed location doesn't exist.")
        } else {
            if let placemarks = placemarks, placemarks.count > 0 {
                let location = (placemarks.first?.location)! as CLLocation
                let coordinate = location.coordinate
                self.latitude = Float(coordinate.latitude)
                self.longitude = Float(coordinate.longitude)
                handleActivityIndicator(false)
                
                let submitVC = storyboard?.instantiateViewController(identifier: "LocationFinalizedVC") as! LocationFinalizedVC
                submitVC.locationRetrieved = locationField.text
                submitVC.urlRetrieved = linkField.text
                submitVC.latitude = self.latitude
                submitVC.longitude = self.longitude
                
                self.present(submitVC, animated: true, completion: nil)
                
                
            } else {
                handleActivityIndicator(false)
                showFailure(title: "Location Not Well Specified", message: "Try to use the full location name (Ex: California, USA).")
            }
        }
    }
    
    
    
    
    func showFailure(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func handleActivityIndicator(_ isFinding: Bool) {
        if isFinding {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    
    
    
    
    
    // MARK: Keyboard Functions
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if !keyboardIsVisible {
            if locationField.isEditing {
                view.frame.origin.y -= getKeyboardHeight(notification) - 50 - linkField.frame.height - findLocationButton.frame.height
            } else if linkField.isEditing {
                view.frame.origin.y -= getKeyboardHeight(notification) - 50 - findLocationButton.frame.height
            }
            keyboardIsVisible = true
        }
    }
    
    // Function called when screen must be moved down
    @objc func keyboardWillHide(_ notification:Notification) {
        if keyboardIsVisible {
            view.frame.origin.y = 0
            keyboardIsVisible = false
        }
    }
    
    // Get keyboard size for move the screen
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
