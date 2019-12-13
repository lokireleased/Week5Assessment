//
//  ContactListTableViewController.swift
//  Week5Assessment
//
//  Created by tyson ericksen on 12/13/19.
//  Copyright © 2019 tyson ericksen. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        ContactController.shared.fetchContacts { (success) in
            if (success != nil) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.shared.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)

        let contact = ContactController.shared.contacts[indexPath.row]
        cell.textLabel?.text = contact.name

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = ContactController.shared.contacts[indexPath.row]
           guard let index = ContactController.shared.contacts.firstIndex(of: contact) else { return }
            ContactController.shared.deleteContact(contact: contact) { (success) in
                if success {
                    ContactController.shared.contacts.remove(at: index)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destinationVC = segue.destination as? ContactDetailViewController {
                    let contact = ContactController.shared.contacts[indexPath.row]
                    destinationVC.contact = contact
                }
            }
        }
    }
}
