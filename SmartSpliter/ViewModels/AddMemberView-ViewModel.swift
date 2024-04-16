//
//  AddMemberView-ViewModel.swift
//  SmartSpliter
//
//  Created by HubertMac on 16/04/2024.
//

import Foundation
import SwiftUI
import SwiftData

extension AddMemberView {
    
    @Observable
    class ViewModel {
        
        var eventId: UUID
        var newPerson: Person?
        
        var fetchedContacts = [Contact]()
        
        var isConfirmationShowing = false
        var isAlertShowing = false
        
        var repeatedMembers = [String]()
        var personToAddGroup = [Person]()
        
        var alertMessage: Text {
            Text("Can not add ") +
            Text(repeatedMembers, format: .list(type: .and)) +
            Text(" - already in Event Members")
        }
        
        init(eventId: UUID) {
            self.eventId = eventId
        }
        
        func findCurrentEvent(events: [Event]) -> Event {
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
        
        func createNewPerson() -> Person {
             Person()
        }
        
        @MainActor
        func addToEventMembers(personToAddGroup: [Person], currentEvent: Event) {
            for personToAdd in personToAddGroup {
                let newEventMember = EventMember(person: personToAdd, event: currentEvent)
                currentEvent.eventMembers.append(newEventMember)
            }
        }
        
        func checkIfPersonCanBeAdded(currentEvent: Event) {
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
}
