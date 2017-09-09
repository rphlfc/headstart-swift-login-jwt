//
//  User.swift
//  rphlfc
//
//  Created by Raphael Cerqueira on 16/07/17.
//  Copyright © 2017 Mingo Labs. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var id: String?
    var name: String?
    var email: String?
    var token: String?
    
    static var currentUser: User?  {
        get {
            let defaults = UserDefaults.standard
            let user = User()
            if let token = defaults.string(forKey: "token") {
                user.token = token
                user.name = defaults.string(forKey: "name")
                user.email = defaults.string(forKey: "email")
                
                return user
            }
            return nil
        }
        set {
            let defaults = UserDefaults.standard
            if newValue == nil {
                defaults.removeObject(forKey: "token")
                defaults.removeObject(forKey: "name")
                defaults.removeObject(forKey: "email")
            } else {
                defaults.set(newValue?.token, forKey: "token")
                defaults.set(newValue?.name, forKey: "name")
                defaults.set(newValue?.email, forKey: "email")
                defaults.synchronize()
            }
        }
    }
    
    override init() {
        
    }
    
    init(dictionary: [String: Any]) {
        super.init()
        
        self.token = dictionary["token"] as? String
        
        if let userDictionary = dictionary["user"] as? [String: Any] {
            self.name = userDictionary["name"] as? String
            self.email = userDictionary["email"] as? String
        }
        
    }
    
}
