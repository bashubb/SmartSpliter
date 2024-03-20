//
//  AddEditEventView.swift
//  SmartSpliter
//
//  Created by HubertMac on 19/03/2024.
//

import SwiftData
import SwiftUI

struct AddEditEventView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Bindable var event: Event
    var body: some View {
        List {
            // Summary of this event
            Section("Event Details") {
                TextField("Name", text: $event.eventName)
            }
            
            // Add some people from contacts or create
            Section("Members") {
                NavigationLink("Add some people") {
                    AddMemberView(event: event)
                }
                // List of members - total amounts for person - delete posibility
                Text("List of people")
                ForEach(event.eventMembers) { eventMember in
                    VStack {
                        HStack {
                            Text(eventMember.person.firstName)
                            Text(eventMember.person.lastName)
                        }
                        .font(.headline)
                        
                        Group {
                            Text(eventMember.person.phoneNumber)
                            Text("\(eventMember.wallet)")
                        }
                        .font(.caption)
                    }
                }
                .onDelete(perform: deleteEventMember)
            }
            
            Section("Expenses") {
                // Add some expense
                NavigationLink("Add Some expenses") {
                    AddEditExpenseView()
                }
        
                
                
                // List of expenses - delete possibility - expense detailView(choose who from members is contributing in this expense - list of members - removable, how to split?(equaly, fixed amount, summary? )
                Text("List of expenses")
            }
        }
        .navigationTitle("EditEvent")
    }
    
    func deleteEventMember(_ indexSet: IndexSet) {
        for index in indexSet {
            let member = event.eventMembers[index]
            modelContext.delete(member)
        }
        event.eventMembers.remove(atOffsets: indexSet)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Event.self, configurations: config)
        let event = Event(eventName: "Mountain Weekend")
        
        return NavigationStack{
            AddEditEventView(event: event)
                .modelContainer(container)
        }
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
