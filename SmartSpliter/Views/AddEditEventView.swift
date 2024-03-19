//
//  AddEditEventView.swift
//  SmartSpliter
//
//  Created by HubertMac on 19/03/2024.
//

import SwiftUI

struct AddEditEventView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Bindable var event: Event
    var body: some View {
        Form {
            TextField("Name", text: $event.eventName)
            
            // Add some people from contacts or create
        }
    }
}

//#Preview {
//    AddEditEventView(event: Event())
//}
