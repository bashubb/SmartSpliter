//
//  AddMemberView.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import SwiftUI

struct AddMemberView: View {
    
    @State private var members = [EventMember]()
    @State var fetchedContacts = [Contact]()
    // UI to change
    var body: some View {
        VStack {
            HStack{
                
                // button for add person by hand
                Button("Add totally new person") {
                    // AddNewPersonView by navigationLink with path passed?
                    
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
    }
    
    func addMembers() {
        // convert Contact from fetchedContacts to Person and add to EventMember
    }
}

#Preview {
    AddMemberView()
}
