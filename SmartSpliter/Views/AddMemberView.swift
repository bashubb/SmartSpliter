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
    @Environment(\.dismiss) var dismiss
    @Query var events: [Event]
    
    @State var fetchedContacts = [Contact]()
    @State private var showAddingView = false
    
    @State private var isConfirmationShowing = false
    @State private var isAlertShowing = false
    
    @State private var repeatedMembers = [String]()
    @State private var personToAddGroup = [Person]()
    
    var alertMessage: Text {
        Text("Can not add ") +
        Text(repeatedMembers, format: .list(type: .and)) +
        Text(" - already in Event Members")
    }
    
    // UI to change
    var body: some View {
        VStack {
            HStack{
                // button for add person by hand
                Button{
                    showAddingView = true
                    // when added go to AddEditView
                    //confirmation dialog
                } label: {
                    Text("Add new person")
                        .shadow(color: Color.black, radius: 0.2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.blue.opacity(0.3))
                        .clipShape(.rect(cornerRadius: 10))
                }
                
                // add choosen contacts to event
                Button{
                    checkIfPersonCanBeAdded()
                    checkForAlert()
                } label: {
                    Text("Add choosen to event")
                        .foregroundStyle(fetchedContacts.isEmpty ? .gray.opacity(0.2) : .green)
                        .shadow(color: Color.black, radius: 0.2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(fetchedContacts.isEmpty ? .gray.opacity(0.2) : .green.opacity(0.3))
                        .clipShape(.rect(cornerRadius: 10))
                }
            }
            .padding(.top, 20)
            .padding(.horizontal)
            
            // screen for importing from contacts
            // fetch in contact format and convert to person and save as EventMembers
            ImportPersonView(fetchedContacts: $fetchedContacts)
        }
        .background(.bar)
        .sheet(isPresented: $showAddingView) {
            AddNewPersonView(eventId: eventId)
        }
        .confirmationDialog("Want to add them ?", isPresented: $isConfirmationShowing) {
            Button("OK") { 
                addToEventMembers(personToAddGroup: personToAddGroup)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Do you want to add \(fetchedContacts.count) people to the Event Members ? ")
        }
        .alert("Oops", isPresented: $isAlertShowing) { 
            Button("OK") { 
                addToEventMembers(personToAddGroup: personToAddGroup)
                dismiss()
            }
        } message: {
            alertMessage
        }
    }
    
    
    func findCurrentEvent() -> Event {
        let currentEventIndex = events.firstIndex { $0.id == eventId }!
        let currentEvent = events[currentEventIndex]
        
        return currentEvent
    }
    
    func personFromContacts() -> [Person] {
        var newPersonGroup = [Person]()
        for contact in fetchedContacts {
            let newPerson =
            Person(
                id: contact.id,
                firstName: contact.firstName,
                lastName: contact.lastName,
                phoneNumber: contact.phoneNumbers.components(separatedBy: ",").first?.trimmed() ?? ""
            )
            newPersonGroup.append(newPerson)
        }
        return newPersonGroup
    }
    
    func addToEventMembers(personToAddGroup: [Person]) {
        let currentEvent = findCurrentEvent()
        for personToAdd in personToAddGroup {
            let newEventMember = EventMember(person: personToAdd, event: currentEvent)
            currentEvent.eventMembers.append(newEventMember)
        }
        
    }
    
    func checkIfPersonCanBeAdded() {
        let currentEvent = findCurrentEvent()
        for personToAdd in personFromContacts() {
            if currentEvent.eventMembers.contains(where: { $0.person.id == personToAdd.id }) {
                repeatedMembers.append("\(personToAdd.firstName + " " + personToAdd.lastName)")
            } else {
                personToAddGroup.append(personToAdd)
            }
        }
    }
    
    func checkForAlert() {
        if repeatedMembers.isNotEmpty{
            isAlertShowing = true
        } else {
            isConfirmationShowing = true
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
