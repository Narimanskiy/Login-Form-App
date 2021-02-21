//
//  SignInViewController.swift
//  Login Form App
//
//  Created by Нариман on 21.02.2021.
//

import UIKit

struct TestUnitResponse<T: Codable>: Codable {
    
   var success: String
    var response: T

}

struct LoginData: Codable {
    
    var token: String
}

struct ErrorData: Codable {
    
    var error_msg: String
    var error_code: Int
}

class SignInViewController: UIViewController {

    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signinButtonTapped(_ sender: Any) {
        print("LOGIN")
        
        //Validate required fields are not empty
        if (userNameTextField.text?.isEmpty)! ||
            (userPasswordTextField.text?.isEmpty)!
        {
            //Display Alert message and return
            displayMessage(userMessage: "All field are quired to fill in")
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
        
        
        //Send HTTP Request
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
            
            do {

                
                let response = try JSONDecoder().decode(TestUnitResponse<LoginData>.self, from: data!)
                print(response.response.token)
                

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
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)

            let OKAction = UIAlertAction(title: "OK", style: .default)
            { (action:UIAlertAction!) in
                //Code in this block will trigger when OK button tapped.
                print("OK button tapped")
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

