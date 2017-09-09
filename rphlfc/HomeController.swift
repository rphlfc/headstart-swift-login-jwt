//
//  HomeController.swift
//  rphlfc
//
//  Created by Raphael Cerqueira on 16/07/17.
//  Copyright © 2017 Mingo Labs. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoutButton.layer.cornerRadius = 5
        
        checkIfUserIsLoggedIn();
    }
    
    func checkIfUserIsLoggedIn() {
        // user is not logged in
        if User.currentUser == nil {
            perform(#selector(logout), with: nil, afterDelay: 0)
        } else {
            fetchUser()
        }
        
    }
    
    func fetchUser() {
        userNameLabel.text = User.currentUser?.name
    }
    
    @IBAction func handleLogout(_ sender: Any) {
        showConfirmation()
    }
    
    func showConfirmation() {
        let alertController = UIAlertController.init(title: "Sair", message: "Deseja realmente sair?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction.init(title: "Sim", style: .destructive, handler: { (action) in
            self.logout()
        }))
        alertController.addAction(UIAlertAction.init(title: "Cancelar", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func logout() {
        User.currentUser = nil
        
        if let loginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as? LoginController {
            loginController.homeController = self
            let navController = UINavigationController.init(rootViewController: loginController)
            present(navController, animated: true, completion: nil)
        }
    }
    
}
