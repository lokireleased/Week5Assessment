//
//  ContactDetailViewController.swift
//  Week5Assessment
//
//  Created by tyson ericksen on 12/13/19.
//  Copyright © 2019 tyson ericksen. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var contact: Contact? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text, let email = emailTextField.text, let phoneNumber = phoneNumberTextField.text else { return }
        if let contact = contact {
            ContactController.shared.updateContact(contact: contact) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
             ContactController.shared.createContact(name: name, email: email, phoneNumber: phoneNumber) { (success) in
                       if (success != nil) {
                           DispatchQueue.main.async {
                               self.navigationController?.popViewController(animated: true)
                           }
                       }
                   }
                }
            }
    
    func updateViews() {
        guard let contact = contact else { return }
        nameTextField.text = contact.name
        emailTextField.text = contact.email
        phoneNumberTextField = contact.phoneNumber
    }
}
