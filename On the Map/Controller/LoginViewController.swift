//
//  LogInViewController.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 3/23/21.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var keyboardIsVisible = false
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
        self.activityIndicator.hidesWhenStopped = true
        
      
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    // TODO: If credentials are invalid send an alert indicating the failure
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        fieldsChecker()
        setLoggingIn(true)
        UdacityAPI.login(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))

                
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        

        
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
        
        
    }
    
    
    
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        
        
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginSuccessful", sender: nil)
            }
        } else {
            showFailure(title: "Login Failed", message: error?.localizedDescription ?? "")
        }
        
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        DispatchQueue.main.async {
            if loggingIn {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
            self.emailTextField.isEnabled = !loggingIn
            self.passwordTextField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
        }
        
         
      
        
       
    }
    
    func showFailure(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func fieldsChecker() {
        
       if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!  {
           DispatchQueue.main.async {
               let alert = UIAlertController(title: "Credentials were not filled in", message: "Please fill both email and password", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
        

       } else {
           setLoggingIn(true)
       }
   }
    
    // Function called when keyboard must be shown and the screen must be moved up
    @objc func keyboardWillShow(_ notification:Notification) {
        if !keyboardIsVisible && (emailTextField.isEditing || passwordTextField.isEditing) {
            view.frame.origin.y -= loginButton.frame.height
            keyboardIsVisible = true
        }
    }
    
    // Function called when screen must be moved down
    @objc func keyboardWillHide(_ notification:Notification) {
        if keyboardIsVisible {
            view.frame.origin.y += loginButton.frame.height
            keyboardIsVisible = false
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Text field delegate functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}


