//
//  AddNewPersonView.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import SwiftData
import SwiftUI

struct AddNewPersonView: View {
    @Environment(\.modelContext) var modelContext
    @State private var firstName: String
    @State private var lastName: String
    @State private var phoneNumber: Int
    
    @Bindable var event: Event
    
    var body: some View {
        // If adding new person show buttons: save and add to event
        Form {
            TextField("First Name",text: $firstName)
            TextField("Last Name", text: $lastName)
            TextField("Phone Number", value: $phoneNumber, format: .number)
        }
    }
    
    func addNewPerson() {
        let newPerson = Person(firstName: firstName, lastName: lastName, phoneNumber: String(phoneNumber))
        let eventMember = EventMember(eventAmount: 0, person: newPerson, event: event)
        event.eventMembers.append(eventMember)
    }
}



