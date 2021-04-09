//
//  StudentsTableViewController.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 3/29/21.
//

import Foundation
import UIKit

class MapsTableVC: UIViewController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var addPinButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    
    
    var results = [StudentInformation]()
    
    /*
    func getStudentData() {
        UdacityAPI.getStudentLocation(objectID: String, completion:{ (data, error) in
            
            DispatchQueue.main.async {
                guard let data = data else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                
            }
        })
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        UdacityAPI.deletingSession { (Bool, Error) in
            if self.logoutButton.isEnabled {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
     */
 }
