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
        VStack(spacing:0) {
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .shadow(color: Color.black, radius: 0.2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.red.opacity(0.3))
                        .clipShape(.rect(cornerRadius: 10))
                }
                
                Spacer()
                
                Button {
                    addNewPerson()
                    router.path.removeLast(router.path.count - 1)
                } label : {
                    Text("Save")
                        .shadow(color: Color.black, radius: 0.2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.green.opacity(0.3))
                        .clipShape(.rect(cornerRadius: 10))
                }
                .disabled(firstName.isEmpty || phoneNumber.isEmpty)
            }
            .padding()
            .padding(.horizontal)
            .background(.bar)
            
            Form {
                Section("First Name") {
                    TextField("type name",text: $firstName)
                }
                Section("Last Name") {
                    TextField("type last name", text: $lastName)
                }
                Section("Phone Number") {
                    TextField("type phone number", text: $phoneNumber)
                        .keyboardType(.namePhonePad)
                }
                
            }
            .scrollDisabled(true)
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




