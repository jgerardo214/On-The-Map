//
//  LogInViewController.swift
//  On the Map
//
//  Created by Jonathan Gerardo on 3/23/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }
    
  

    @IBAction func loginButtonPressed(_ sender: Any) {
        UdacityAPI.login(emailTextField.text!, passwordTextField.text!) { (successful, error) in
            if let error = error {
                print(error.localizedDescription)
                let errorAlert = UIAlertController(title: "Error", message: "Houston, there is a problem", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in return
                    
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
            
            let map = self.storyboard?.instantiateViewController(identifier: "TabBarController") as! UITabBarController
            self.present(map, animated: true, completion: nil)
        }
        
        
       
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        }
    }
    
    func setLoggingIn(_ logginIn: Bool) {
        emailTextField.isEnabled = !logginIn
        passwordTextField.isEnabled = !logginIn
        loginButton.isEnabled = !logginIn
        
    }
}

