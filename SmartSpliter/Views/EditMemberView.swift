//
//  AddEditPersonView.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import SwiftUI

struct EditMemberView: View {
    @Binding var contact: Contact
    var body: some View {
        
        // If adding new person show buttons: save and add to event
        Form {
            TextField("First Name",text: $contact.firstName)
            TextField("Last Name", text: $contact.lastName)
            // Add phone number
        }
       
    }
}

#Preview {
    EditMemberView(contact:
            .constant(Contact(firstName: "", lastName: "", phoneNumbers: "")))
}
