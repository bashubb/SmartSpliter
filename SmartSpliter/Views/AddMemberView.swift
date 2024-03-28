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
    
    @State var fetchedContacts = [Contact]()
    @State private var showAddingView = false
    
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
                    
                }
                .buttonStyle(.bordered)
                .tint(.green)
                
             
            }
            
            // screen for importing from contacts
            // fetch in contact format and convert to person and save as EventMembers
            ImportPersonView(fetchContacts: $fetchedContacts)
        }
       .padding(.top, 20)
       .sheet(isPresented: $showAddingView) {
           AddNewPersonView(eventId: eventId)
       }
    }
    
    func addMembers() {
        // convert Contact from fetchedContacts to Person and add to EventMember
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
