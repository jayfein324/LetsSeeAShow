//
//  ViewController.swift
//  LetsSeeAShow
//
//  Created by Jay Fein on 11/26/19.
//  Copyright © 2019 Jay Fein. All rights reserved.
//

import UIKit
import FirebaseUI

class ViewController: UIViewController {
    
    @IBOutlet weak var homeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeImage.layer.cornerRadius = 200
        self.homeImage.clipsToBounds = true
        // Do any additional setup after loading the view.
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
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    
    }

extension ViewController: FUIAuthDelegate {
    
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        //  Check if there was an error
        let newUser : User =  Auth.auth().currentUser!
        
        //  guard is like saying if error == nil then do nothing else { Log the error and then return }
        guard error == nil else {
            print(error?.localizedDescription as Any)
            return
        }
        //authDataResult?.user.uid
        performSegue(withIdentifier: "goHome", sender: self)

}
}
