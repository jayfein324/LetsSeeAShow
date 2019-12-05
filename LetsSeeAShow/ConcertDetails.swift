//
//  ConcertDetails.swift
//  LetsSeeAShow
//
//  Created by Jay Fein on 12/4/19.
//  Copyright © 2019 Jay Fein. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Firebase
import FirebaseUI

class ConcertDetails: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    let ref = Database.database().reference()
    
   @IBOutlet weak var concertImage: UIImageView!
    @IBOutlet weak var concertTitle: UILabel!
    @IBOutlet weak var concertVenueAndLoc: UILabel!
    @IBOutlet weak var concertTime: UILabel!
    @IBOutlet weak var concertPrice: UILabel!
    @IBOutlet weak var goingButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedEvent : Event!
    var usersGoing = [String]()
    var userObjectsGoing = [UserComplete]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let image = selectedEvent.performers[0].image {
            let url = URL(string: image)
            concertImage.kf.setImage(with: url)
        }
        
        concertTime.text = dateFormat(date : selectedEvent.datetime_local)
        concertTitle.text = selectedEvent.short_title
        concertVenueAndLoc.text = selectedEvent.venue.name
        concertPrice.text = "Ave price: " + String(selectedEvent.stats.median_price)
        updateUsersGoing {
            if self.usersGoing.contains(Auth.auth().currentUser!.uid) {
                self.goingButton.setTitle("I'm Not Going", for : .normal)
                self.goingButton.backgroundColor = .red
            } else {
                self.goingButton.setTitle("I'm Going!", for: .normal)
                self.goingButton.backgroundColor = .green
            }
        }
    }
    
    func dateFormat(date : String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let yourDate = formatter.date(from: date)
        formatter.dateFormat = "dd-MMM-yyyy  HH:mm"
        return formatter.string(from: yourDate!)
    }
    
    @IBAction func goingPressed(_ sender: UIButton) {
        if let id = Auth.auth().currentUser?.uid {
            if !usersGoing.contains(id) {
                ref.child("events").child(String(selectedEvent.id)).child("users").updateChildValues([id : id])
                DispatchQueue.main.async {
                let alert = UIAlertController(title: "Thank You", message: "Congrats! Have fun!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                sender.setTitle("I'm Not Going", for: .normal)
                sender.backgroundColor = .red
                }
            } else {
                ref.child("events").child(String(selectedEvent.id)).child("users").child(id).removeValue()
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Sad", message: "Sorry to see you go!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "I'm sad too", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    sender.setTitle("I'm Going!", for: .normal)
                    sender.backgroundColor = .green
                }
            }
        }
        updateUsersGoing(callback: nil)
    }
    
    func updateUsersGoing(callback: (() -> Void)?) {
        var whosGoing = [String]()
        ref.child("events").child(String(selectedEvent.id)).child("users").observeSingleEvent(of: .value, with: {(snapshot) in
            for case let child as DataSnapshot in snapshot.children {
                whosGoing.append(child.value as! String)
            }
            self.usersGoing = whosGoing
            if callback != nil {
                callback!()
            }
            self.updateUsersComplete()
        })
    }
    
    func updateUsersComplete() {
        var children = [UserComplete]()
        ref.child("users").observeSingleEvent(of: .value, with: {(snapshot) in
            for case let child as DataSnapshot in snapshot.children {
                let newUserComplete = UserComplete(child : child)
                children.append(newUserComplete)
            }
            self.userObjectsGoing = children.filter {self.usersGoing.contains($0.id)}
            self.tableView.reloadData()
            print(self.userObjectsGoing)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userObjectsGoing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UITableViewCell
        cell.textLabel?.text = userObjectsGoing[indexPath.row].name
        cell.detailTextLabel?.text = "Age: " + String(userObjectsGoing[indexPath.row].age)
        return cell
    }
}

