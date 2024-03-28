//
//  AddNewPersonView.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import SwiftData
import SwiftUI

struct AddNewPersonView: View {
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var phoneNumber: String = ""
    @Query var events: [Event]
    
    var eventId: UUID
    
    var body: some View {
        // If adding new person show buttons: save and add to event
        Form {
            TextField("First Name",text: $firstName)
            TextField("Last Name", text: $lastName)
            TextField("Phone Number", text: $phoneNumber)
                .keyboardType(.namePhonePad)
        }
        Button("Save") {
            addNewPerson()
            router.path.removeLast(router.path.count - 1)
        }
    }
    
    func addNewPerson() {
        let currentEventIndex = events.firstIndex { $0.id == eventId }!
        let currentEvent = events[currentEventIndex]
        let newPerson = Person(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        let eventMember = EventMember(person: newPerson, event: currentEvent)
        currentEvent.eventMembers.append(eventMember)
    }
}




