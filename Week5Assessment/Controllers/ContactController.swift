//
//  ContactController.swift
//  Week5Assessment
//
//  Created by tyson ericksen on 12/13/19.
//  Copyright © 2019 tyson ericksen. All rights reserved.
//

import CloudKit

class ContactController {
    
    static let shared = ContactController()
    
    var contacts: [Contact] = []

    
    func createContact(name: String, email: String?, phoneNumber: String?, completion: @escaping (Contact?) -> Void) {
        let newContact = Contact(name: name)
        contacts.append(newContact)
        let record = CKRecord(contact: newContact)
        CKContainer.default().publicCloudDatabase.save(record) { (record, error) in
            if let error = error {
                print("Error in saving contact", error.localizedDescription)
                completion(nil)
                return
            }
            guard let record = record, let contact = Contact(ckRecord: record) else { completion(nil); return }
            completion(contact)
        }
    }

    func deleteContact(contact: Contact, completion: @escaping (Bool) -> Void) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: contact.recordID) { (recordID, error) in
            if let error = error {
                print("Error, could not delete Contact", error.localizedDescription)
                completion(false)
                return
            }
            guard let index = self.contacts.firstIndex(of: contact) else { completion(false); return }
            self.contacts.remove(at: index)
            completion(true)
        }
    }

    func updateContact(contact: Contact, completion: @escaping (Bool) -> Void) {
        let record = CKRecord(contact: contact)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (record, _, error) in
            if let error = error {
                print("Error, could not update Contact", error.localizedDescription)
                completion(false)
                return
            }
            guard let record = record?.first else { completion(false); return }
            completion(true)
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }

    func fetchContacts(completion: @escaping ([Contact]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ContactStrings.contactKey, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in retrieving Contacts", error.localizedDescription)
                completion(nil)
                return
            }
            guard let records = records else { completion(nil); return }
            let contacts = records.compactMap { Contact(ckRecord: $0) }
            self.contacts = contacts
            completion(contacts)
        }
    }
}
