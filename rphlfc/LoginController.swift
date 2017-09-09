//
//  ViewController.swift
//  rphlfc
//
//  Created by Raphael Cerqueira on 15/07/17.
//  Copyright © 2017 Mingo Labs. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loginRegisterButton: UIButton!
    @IBOutlet weak var loginRegisterSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var nameTextField: FormTextField!
    @IBOutlet weak var nameTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: FormTextField!
    @IBOutlet weak var passwordTextField: FormTextField!
    
    var homeController: HomeController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.layer.borderColor = UIColor.lightGray.cgColor
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.cornerRadius = 5
        
        self.loginRegisterButton.layer.cornerRadius = 5
        
        self.loginRegisterSegmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        
        handleLoginRegisterChange()
    }
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        containerViewHeightConstraint.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 152
        
        nameTextFieldHeightConstraint.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 50
    }
    
    @IBAction func handleLoginRegister(_ sender: Any) {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        let url = URL(string: "http://localhost:3000/users/authenticate");
        
        let user = ["email": email, "password": password]
        
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: user, options: [])
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] else { return }
                print("json: ", json);
                let success = json["success"] as? Bool ?? false
                if success {
                    
                    self.didLogin(json);
                    
                } else {
                    let message = json["msg"] as? String ?? ""
                    let alertController = UIAlertController.init(title: "Erro", message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            } catch let jsonErr {
                print(jsonErr)
            }
            
        }.resume()
    }
    
    func handleRegister() {
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        let url = URL(string: "http://localhost:3000/users/register");
        
        let user = ["name": name, "email": email, "password": password]
        
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: user, options: [])
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] else { return }
                print("json: ", json);
                let success = json["success"] as? Bool ?? false
                if success {
                    
                    self.didLogin(json);
                    
                } else {
                    let message = json["msg"] as? String ?? ""
                    let alertController = UIAlertController.init(title: "Erro", message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            } catch let jsonErr {
                print(jsonErr)
            }
            
        }.resume()
    }
    
    func didLogin(_ json: [String: Any]) {
        let user = User(dictionary: json);
        User.currentUser = user;
        
        self.homeController?.fetchUser()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

