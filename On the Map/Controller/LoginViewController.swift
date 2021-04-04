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
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
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
            
        }
        
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        
        if loggingIn {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
}


