//
//  SignInViewController.swift
//  Login Form App
//
//  Created by Нариман on 21.02.2021.
//

import UIKit
import SwiftKeychainWrapper


class SignInViewController: UIViewController {

    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signinButtonTapped(_ sender: Any) {
        
        
        let userLogin = userNameTextField.text
        let userPassword = userPasswordTextField.text
        
        //Validate required fields are not empty
        if (userLogin?.isEmpty)! ||
            (userPassword?.isEmpty)!
        {
            //Display Alert message and return
            displayMessage(userMessage: "One of the required fields is missing")
            return
        }
        
        
        //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        //Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        //If needed, you can prevent Activity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        //Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        
        //Send HTTP Request to perform Sign in
        let baseURL = URL(string: "http://82.202.204.94/api/login")
        var request = URLRequest(url: baseURL!)
        request.httpMethod = "POST"
        request.setValue("12345", forHTTPHeaderField: "app-key")
        request.setValue("1", forHTTPHeaderField: "v")

        let userData = ["login": userNameTextField.text!, "password": userPasswordTextField.text!] 

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: userData, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong. Try again")
            return
        }

        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil {
                
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later.")
                print("error=\(String(describing: error))")
                return
            }
            
            do {

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(TestUnitResponse<LoginData>.self, from: data!)
            
                
                if let token = response.response?.token  {
                    KeychainWrapper.standard.set(token, forKey: "token")
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "paymentSegue", sender: nil)
                        
                }
        
                } else  {
                    
                    if let errorMessage = response.error?.errorMsg {
                        self.displayMessage(userMessage: errorMessage)
                        return
                    }
                }
            } catch {
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            }
        }
        task.resume()

 }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    func displayMessage(userMessage: String) -> Void {
        DispatchQueue.main.async
        {
            let alertController = UIAlertController(title: "", message: userMessage, preferredStyle: .alert)

            let OKAction = UIAlertAction(title: "OK", style: .default)
            { (action:UIAlertAction!) in
                //Code in this block will trigger when OK button tapped.
                DispatchQueue.main.async
                {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    

}

