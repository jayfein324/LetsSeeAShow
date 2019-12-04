//
//  HomeTableViewController.swift
//  LetsSeeAShow
//
//  Created by Jay Fein on 12/3/19.
//  Copyright © 2019 Jay Fein. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var events = [Event]()
    
    let endpoint = "https://api.seatgeek.com/2/events?client_id=MTQ3OTM2NjB8MTU3NTQwMjI4OC45Mw&type.name=concert&lat=39.952583&lon=-75.165222&range=30mi&sort=score.desc&per_page=100"

    override func viewDidLoad() {
        super.viewDidLoad()
        makeApiRequest()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
