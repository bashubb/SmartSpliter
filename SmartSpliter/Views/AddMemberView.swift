//
//  AddMemberView.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import SwiftData
import SwiftUI

struct AddMemberView: View {
    var eventId: UUID
    
    @Environment(\.modelContext) var modelContext
    @State var fetchedContacts = [Contact]()
    @State private var showAddingView = false
    @Query var events: [Event]
    
    
    // UI to change
    var body: some View {
       VStack {
            HStack{
                
                // button for add person by hand
                Button("Add totally new person") {
                    showAddingView = true
                    
                    
                    // when added go to AddEditView
                    //confirmation dialog
                }
                .buttonStyle(.bordered)
                .tint(.blue)
                
                
                // add choosen contacts to event
                Button("Add choosen to event"){
                    addMembersFromContacts()
                }
                .buttonStyle(.bordered)
                .tint(.green)
                
             
            }
            
            // screen for importing from contacts
            // fetch in contact format and convert to person and save as EventMembers
            ImportPersonView(fetchedContacts: $fetchedContacts)
        }
       .padding(.top, 20)
       .sheet(isPresented: $showAddingView) {
           AddNewPersonView(eventId: eventId)
       }
    }
    
    func addMembersFromContacts() {
        for contact in fetchedContacts {
            print(contact.id)
            let newPerson =
            Person(
                id: contact.id,
                firstName: contact.firstName,
                lastName: contact.lastName,
                phoneNumber: contact.phoneNumbers.components(separatedBy: ",").first?.trimmed() ?? ""
            )
            let currentEventIndex = events.firstIndex { $0.id == eventId }!
            let currentEvent = events[currentEventIndex]
            if currentEvent.eventMembers.contains(where: { $0.id == newPerson.id }) {
                return
            } else {
                let newEventMember = EventMember(person: newPerson, event: currentEvent)
                currentEvent.eventMembers.append(newEventMember)
            }
        }
    }
    
    
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Event.self, configurations: config)
        
        return NavigationStack{
            AddMemberView(eventId: UUID())
                .modelContainer(container)
        }
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
