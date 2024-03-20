//
//  ContactManager.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import Contacts
import Foundation


class ContactManager {
    
   static func fetchAllContacts() async -> [Contact]{
        
        var contacts = [Contact]()
        //Get access to the Contacts store
        let store = CNContactStore()
        
        // Specify which data keys we want to fetch
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        //Create fetch request
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        
        // Call method to fetch all contacts
        do {
            try store.enumerateContacts(with: fetchRequest) { contact, result in
                
                guard contact.givenName.isReallyEmpty == false  else { return }
                guard contact.phoneNumbers.isEmpty == false else { return }
                
                var fetchedContact = Contact(
                    firstName: contact.givenName.trimmed(),
                    lastName: contact.familyName.trimmed(),
                    phoneNumbers: "")
                
                for number in contact.phoneNumbers {
                    fetchedContact.phoneNumbers += "\(number.value.stringValue),"
                }
                
                contacts.append(fetchedContact)
            }
            return contacts.sorted{$0.firstName < $1.firstName}
            
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }

}

