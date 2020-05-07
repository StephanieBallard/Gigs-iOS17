//
//  GigsTableViewController.swift
//  Gigs_iOS17
//
//  Created by Stephanie Ballard on 5/5/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    let gigController = GigController()
    var gigs: [Gig] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "SignupLoginShowSegue", sender: self)
        
        // TODO: fetch gigs here
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        cell.textLabel?.text = gigs[indexPath.row].title
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        cell.detailTextLabel?.text = dateFormatter.string(from: gigs[indexPath.row].dueDate)
        
        return cell
    }
    
    // MARK: - Navigation
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignupLoginShowSegue" {
            guard let destination = segue.destination as? LoginViewController else { return }
            destination.gigController = gigController
        } else if segue.identifier == "ViewGigShowSegue" {
            guard let destination = segue.destination as? GigDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let gig = gigController.gigs[indexPath.row]
            destination.gigController = gigController
            destination.gig = gig
        } else if segue.identifier == "AddGigShowSegue" {
            guard let destination = segue.destination as? GigDetailViewController else { return }
            destination.gigController = gigController
        }
        
    }

}
