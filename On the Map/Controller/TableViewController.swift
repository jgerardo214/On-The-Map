//
//  StudentsTableViewController.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 3/29/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var iconPin: UIImageView!
    @IBOutlet weak var mediaURL: UILabel!
}

class TableView: UITableViewController {
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var results = [StudentInformation]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    // MARK: - TableView methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return appDelegate.studentLocations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeue a cell and populate it with text from the correct prompt.
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableViewCell
        cell.studentName?.text = appDelegate.studentLocations[(indexPath as NSIndexPath).row].firstName! + " " + appDelegate.studentLocations[(indexPath as NSIndexPath).row].lastName!
        cell.mediaURL?.text = appDelegate.studentLocations[(indexPath as NSIndexPath).row].mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableCell = tableView.cellForRow(at: indexPath) as! TableViewCell
        let app = UIApplication.shared
        if let toOpen = tableCell.mediaURL?.text! {
            app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
        }
    }
   
    @IBAction func logoutButtonPressed(_ sender: Any) {
        UdacityAPI.logout(completion: handleLogoutResponse(success:error:))
    }
    
    
    @IBAction func refreshButtonPRessed(_ sender: Any) {
        UdacityAPI.getStudentLocation(completion: handleStudentLocationsResponse(locations:error:))
    }
    
    @IBAction func addLocation(_ sender: Any) {
        let informationPostingVC = storyboard?.instantiateViewController(withIdentifier: "InformationPostingVC") as! InformationPostingVC
        present(informationPostingVC, animated: true, completion: nil)
    }
    
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            showFailure(title: "Logout Failed", message: "An Error has occured. Try again.")
        }
    }
    
    func handleStudentLocationsResponse(locations: [StudentLocation], error: Error?) {
        //refreshButton.isEnabled = true
        
        if error == nil {
            appDelegate.studentLocations = locations
            self.tableView.reloadData()
        } else {
            showFailure(title: "No location found", message: error?.localizedDescription ?? "")
        }
    }
    
    func showFailure(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

     
 }
