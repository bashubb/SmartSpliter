//
//  ImportPersonView.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import SwiftUI

struct ImportPersonView: View {
    
    @State private var contacts = [Contact]()
    @State private var selectedItems = Set<UUID>()
    
    @Binding var fetchContacts: [Contact]
    
    var selectedCounted: String {
        "\(selectedItems.count) items"
    }
    
    var body: some View {
        VStack {
            if !contacts.isEmpty {
                FilteringList(contacts, filterKeys: \.firstName, \.lastName, \.phoneNumbers ) { contact in
                    MultiSelectionRow(id: contact.id, selectedItems: $selectedItems, content: Row(contact:contact))
                    .listRowBackground(selectedItems.contains(contact.id) ?
                                       Color.gray.opacity(0.3) : .clear)
                }
                .padding(.top)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
                .navigationTitle(selectedCounted)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    if !selectedItems.isEmpty {
                        Button("clear"){
                            selectedItems.removeAll()
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .task {
            contacts = await ContactManager.fetchAllContacts()
        }
        .onChange(of: selectedItems) { 
            selectedItems.removeAll()
            Task {
                await findChoosenContacts()
            }
            
        }
        
    }
    
    func findChoosenContacts() async {
        for contact in contacts {
            if selectedItems.contains(contact.id) && !fetchContacts.contains(where: { $0.id == contact.id }) {
                fetchContacts.append(contact)
            }
        }
    }
}


