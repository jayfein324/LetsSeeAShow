//
//  DetailViewController.swift
//  LetsSeeAShow
//
//  Created by Jay Fein on 12/2/19.
//  Copyright © 2019 Jay Fein. All rights reserved.
//

import UIKit
import FirebaseUI
import Firebase

class DetailViewController: UIViewController {

    var ref = Database.database().reference()

    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var details: UITextField!
    
    @IBAction func savePressed(_ sender: Any) {
        if !details.text!.isEmpty && !age.text!.isEmpty {
            if let ageNum = Int(age.text!) {
                updateAge(withAge : ageNum)
                updateDetails(withDetails : details.text!)
                performSegue(withIdentifier: "goMainScreen", sender: self)
            } else {
                let alert = UIAlertController(title: "Invalid Age", message: "Please Enter a Valid Age", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Blank Fields", message: "Please Fill out all of the Information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateAge(withAge age : Int) {
        let userToUpdateRef = ref.child("users").child(Auth.auth().currentUser!.uid).child("age")
        userToUpdateRef.setValue(age)
    }
    
    func updateDetails(withDetails details : String) {
        let userToUpdateRef = ref.child("users").child(Auth.auth().currentUser!.uid).child("details")
        userToUpdateRef.setValue(details)
    }
}

