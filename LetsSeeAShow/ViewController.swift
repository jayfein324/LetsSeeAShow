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

    override func viewDidLoad() {
        super.viewDidLoad()
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
        authUI?.delegate = self as? FUIAuthDelegate
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
        
        //  guard is like saying if error == nil then do nothing else { Log the error and then return }
        guard error == nil else {
            print(error?.localizedDescription as Any)
            return
        }
        //authDataResult?.user.uid
        performSegue(withIdentifier: "goHome", sender: self)
        
    }
}
