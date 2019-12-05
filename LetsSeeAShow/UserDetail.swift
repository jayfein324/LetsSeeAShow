//
//  UserDetail.swift
//  LetsSeeAShow
//
//  Created by Jay Fein on 12/4/19.
//  Copyright © 2019 Jay Fein. All rights reserved.
//

import UIKit

class UserDetail: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var bio: UILabel!
    var selectedUser : UserComplete!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = selectedUser.name
        age.text = String(selectedUser.age)
        email.text = selectedUser.email
        phone.text = selectedUser.number
        bio.text = selectedUser.details
    }
    
}
