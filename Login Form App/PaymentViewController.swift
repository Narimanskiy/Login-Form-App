//
//  PaymentViewController.swift
//  Login Form App
//
//  Created by Нариман on 21.02.2021.
//

import UIKit
import SwiftKeychainWrapper


class PaymentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var paymentsAll = [PaymentData]()
    var selectedIndex = NSIndexPath()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentsAll.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath as NSIndexPath
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndex as IndexPath {

                return 100 //Size you want to increase to
            }
            return 70 // Default Size
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "allCell")
        let payment = paymentsAll[indexPath.row]
        
        cell.textLabel?.text = " \(payment.desc!) " + " Сумма: \(payment.amount!)" + " Валюта: \(payment.currency ?? "")" + " Создано: \(payment.created!)"
        cell.textLabel?.numberOfLines = 0
       

        return cell
    }
    
    @IBOutlet weak var paymentTableView: UITableView!
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "token")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
       
        
        if let token = KeychainWrapper.standard.string(forKey: "token") {
            //Send HTTP request
            let baseURL = URL(string: "http://82.202.204.94/api/payments?token=\(token)")
            var request = URLRequest(url: baseURL!)
            request.httpMethod = "GET"
            request.addValue("12345", forHTTPHeaderField: "app-key")
            request.addValue("1", forHTTPHeaderField: "v")
            
            let task = URLSession.shared.dataTask(with: request) {
                (data: Data?, response: URLResponse?, error: Error?) in
                
                if error != nil {
                    
                    print("error=\(String(describing: error))")
                    return
                }

                do {

                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let data = try decoder.decode(TestUnitResponse<[PaymentData]>.self, from: data!)
                    if let payments = data.response {
                        self.paymentsAll = payments
                        print(self.paymentsAll)
                    } else {
                        if let errorMessage = data.error?.errorMsg {
                            self.displayMessage(userMessage: errorMessage)
                            return
                        }
                    }

                } catch {
                    print("Warning, something wrong!")
                }
            
        }
            task.resume()
        
        }
    }
    
    func displayMessage(userMessage: String) -> Void {
        DispatchQueue.main.async
        {
            let alertController = UIAlertController(title: "", message: userMessage, preferredStyle: .alert)

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
