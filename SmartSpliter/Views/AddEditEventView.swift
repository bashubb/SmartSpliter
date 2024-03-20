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
        Form {
            
            // Summary of this event
            
            TextField("Name", text: $event.eventName)
            
            // Add some people from contacts or create
            // List of members - total amounts for person - delete posibility
            
            // Add some expenss
            // List of expenses - delete possibility - expense detailView(choose who from members is contributing in this expense - list of members - removable, how to split?(equaly, fixed amount, summary? )
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Event.self, configurations: config)
        let event = Event(eventName: "Mountains")
        
        return AddEditEventView(event: event)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
