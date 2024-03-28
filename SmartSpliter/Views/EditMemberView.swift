//
//  AddEditPersonView.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import SwiftUI

struct EditMemberView: View {
    @Bindable var eventMember: EventMember
   
    @State private var phoneNumber: Int?
    var body: some View {
        
        // If adding new person show buttons: save and add to event
        Form {
            TextField("First Name",text: $eventMember.person.firstName)
            TextField("Last Name", text: $eventMember.person.lastName)
            TextField("Phone Number",text: $eventMember.person.phoneNumber)
                .keyboardType(.numbersAndPunctuation)
        }
        
       
    }
}

//#Preview {
//    EditMemberView()
//}
