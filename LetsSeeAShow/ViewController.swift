//
//  ViewController.swift
//  LetsSeeAShow
//
//  Created by Jay Fein on 11/26/19.
//  Copyright © 2019 Jay Fein. All rights reserved.
//

import UIKit
import FirebaseUI
import Firebase

class ViewController: UIViewController {
    
    // Create empty array of users
    var users = [User]()
    
    // Get a reference to the database
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        // Updates the users
        ref.child("users").observe(.value) { snapshot in
            var newUsers = [User]()
            if let userDicts = snapshot.value as? [String: [String : Any]] {
                for eachUser in userDicts {
                    let dictValue = eachUser.value
                    if let name = dictValue["name"] as? String, let email = dictValue["email"] as? String, let id = eachUser.key as? String {
                        newUsers.append(User(name: name, email: email, id: id))
                    }
                }
            }
            self.users = newUsers
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        // Get the default Auth UI Object
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            // Log the error
            return
        }
        
        // Set ourselves as the delegate
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth()]
        
        // Get a reference to the auth UI view contoller
        let authViewController = authUI?.authViewController()
        
        // Show it.
        present(authViewController!, animated: true, completion: nil)
    }
    
    // Creates a new user and updates the database
    func createUser(name : String, email : String) {
        let id = Auth.auth().currentUser?.uid
        
        let newUserRef = ref.child("users").child(id!)
        
        // I give the users a default age and details, which will be changed in the details screen
        let newUserDictionary: [String : Any] = [
            "name" : name,
            "email" : email,
            "id" : id!,
        ]
        
        newUserRef.setValue(newUserDictionary)
    }
    
    // returns true if a user exists already in the database based on email
    func checkUser(withEmail userEmail: String) -> Bool {
        var userExists = false
        for user in users {
            if user.email == userEmail {
                userExists = true
            }
        }
        return userExists
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    }

extension ViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        let newUser = Auth.auth().currentUser!
        
        let alreadyExists = checkUser(withEmail: newUser.email!)
        
        // create new user if user doesn't already exist
        if !alreadyExists {
            createUser(name: newUser.displayName!, email: newUser.email!)
            performSegue(withIdentifier: "goDetails", sender: self)
        } else {
            performSegue(withIdentifier: "goHome", sender: self)
        }

        //  guard is like saying if error == nil then do nothing else { Log the error and then return }
        guard error == nil else {
            print(error?.localizedDescription as Any)
            return
        }
     
}
}
