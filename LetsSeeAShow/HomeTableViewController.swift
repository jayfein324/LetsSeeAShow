//
//  HomeTableViewController.swift
//  LetsSeeAShow
//
//  Created by Jay Fein on 12/3/19.
//  Copyright © 2019 Jay Fein. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseUI
import Firebase

class HomeTableViewController: UITableViewController {
    
    let ref = Database.database().reference()
    var events = [Event]()
 
    let endpoint = "https://api.seatgeek.com/2/events?client_id=MTQ3OTM2NjB8MTU3NTQwMjI4OC45Mw&type.name=concert&lat=39.952583&lon=-75.165222&range=30mi&sort=score.desc&per_page=100"
    
    override func viewDidLoad() {
        configureRefreshControl()
        self.refreshControl?.beginRefreshing()
        super.viewDidLoad()
        makeApiRequest()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        if let image = events[indexPath.row].performers[0].image {
            let url = URL(string: image)
            cell.concertImage.kf.setImage(with: url)
        }
        
        cell.title.text = events[indexPath.row].short_title
        cell.date.text = dateFormat(date: events[indexPath.row].datetime_local)

        return cell
    }

    func dateFormat(date : String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let yourDate = formatter.date(from: date)
        formatter.dateFormat = "MMM d, yyyy  h:mm a"
        return formatter.string(from: yourDate!)
    }
    
    @objc private func makeApiRequest() {
        let url = URL(string: endpoint)! //can I force unwrap this?
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let data = data, error == nil else {
                print("Error: API request failed...")
                return
            }
            
            if let EventData = try? JSONDecoder().decode(EventData.self, from: data) {
                DispatchQueue.main.async {
                    self.events = EventData.events
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
        task.resume()
    }
    
    func createEventsData() {
        let newEventRef = ref.child("events")
        print(events.count)
        for event in events {
            let id = String(event.id)
            newEventRef.child(id)
            let newEventDictionary: [String : Any] = [
                "name" : event.short_title,
                "id" : id
            ]
            newEventRef.child(id).setValue(newEventDictionary)
        }
    }
    
    
    @IBAction func editProfPressed(_ sender: Any) {
        performSegue(withIdentifier: "toDetailEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConcertDetails" {
            let vc = segue.destination as? ConcertDetails
            vc?.selectedEvent = events[self.tableView.indexPathForSelectedRow!.row]
        }
    }
    
    func configureRefreshControl () {
        // Add the refresh control to your UIScrollView object.
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action:
            #selector(makeApiRequest),
                                       for: .valueChanged)
    }

}
