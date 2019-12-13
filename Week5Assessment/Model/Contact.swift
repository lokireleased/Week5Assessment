//
//  Contact.swift
//  Week5Assessment
//
//  Created by tyson ericksen on 12/13/19.
//  Copyright © 2019 tyson ericksen. All rights reserved.
//


import CloudKit

enum ContactStrings {
    static let contactKey = "Contact"
    static let nameKey = "name"
    static let emailKey = "email"
    static let phoneNumberKey = "phoneNumber"
}

class Contact {
    
    var name: String
    var phoneNumber: String
    var email: String
    let recordID: CKRecord.ID
    
    init(name: String, phoneNumber: String = "", email: String = "", recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.recordID = recordID
    }
}

extension Contact : Equatable {
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

extension Contact {
    
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[ContactStrings.nameKey] as? String, let email = ckRecord[ContactStrings.emailKey] as? String, let phoneNumber = ckRecord[ContactStrings.phoneNumberKey] as? String else { return nil }
        
        self.init(name: name, phoneNumber: phoneNumber, email: email, recordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(contact: Contact) {
        self.init(recordType: "Contact", recordID: contact.recordID)
        setValue(contact.name, forKey: ContactStrings.nameKey)
        setValue(contact.email, forKey: ContactStrings.emailKey)
        setValue(contact.phoneNumber, forKey: ContactStrings.phoneNumberKey)
    }
}
