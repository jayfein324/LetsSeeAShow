//
//  User.swift
//  LetsSeeAShow
//
//  Created by Jay Fein on 12/3/19.
//  Copyright © 2019 Jay Fein. All rights reserved.
//

import Foundation
import Firebase

struct User {
    var name : String
    var email : String
    var id : String
}

struct UserComplete {
    var name : String
    var email : String
    var id : String
    var age : Int
    var details : String
    var number : String
    
    init(child : DataSnapshot) {
        name = child.childSnapshot(forPath: "name").value as! String
        email = child.childSnapshot(forPath: "email").value as! String
        id = child.childSnapshot(forPath: "id").value as! String
        age = child.childSnapshot(forPath: "age").value as! Int
        details = child.childSnapshot(forPath: "details").value as! String
        number = child.childSnapshot(forPath: "number").value as! String
    }
}
