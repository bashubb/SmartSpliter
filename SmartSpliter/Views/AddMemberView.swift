//
//  AddMemberView.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import SwiftData
import SwiftUI

struct AddMemberView: View {
   
    @Environment(\.dismiss) var dismiss
    @Query var events: [Event]
    @State private var viewModel: ViewModel
    
    var currentEvent: Event {
        viewModel.findCurrentEvent(events: events)
    }
    
    // UI to change
    var body: some View {
        VStack {
            HStack{
                // button for add person by hand
                Button{
                    viewModel.newPerson = viewModel.createNewPerson()
                    // when added go to AddEditView
                    //confirmation dialog
                } label: {
                    Text("Add new person")
                        .foregroundStyle(.blue)
                        .shadow(color: Color.black, radius: 0.2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.blue.opacity(0.3))
                        .clipShape(.rect(cornerRadius: 10))
                }
                
                // add choosen contacts to event
                Button{
                    viewModel.checkIfPersonCanBeAdded(currentEvent: currentEvent)
                    viewModel.checkForAlert()
                } label: {
                    Text("Add choosen to event")
                        .foregroundStyle(viewModel.fetchedContacts.isEmpty ? .gray.opacity(0.2) : .green)
                        .shadow(color: Color.black, radius: 0.2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.fetchedContacts.isEmpty ? .gray.opacity(0.2) : .green.opacity(0.3))
                        .clipShape(.rect(cornerRadius: 10))
                }
            }
            .buttonStyle(.plain)
            .padding(.top, 20)
            .padding(.horizontal)
            
            // screen for importing from contacts
            // fetch in contact format and convert to person and save as EventMembers
            ImportPersonView(fetchedContacts: $viewModel.fetchedContacts)
        }
        .background(.bar)
        .sheet(item: $viewModel.newPerson) { person in
            AddNewPersonView(newPerson: person) {
                viewModel.addToEventMembers(personToAddGroup: [$0], currentEvent: currentEvent)
            }
            .presentationDetents([.medium])
            .presentationBackground(.bar)
            .presentationCornerRadius(20)
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.disabled)
        }
        .confirmationDialog("Want to add them ?", isPresented: $viewModel.isConfirmationShowing) {
            Button("OK") {
                viewModel.addToEventMembers(personToAddGroup: viewModel.personToAddGroup, currentEvent: currentEvent)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Do you want to add \(viewModel.fetchedContacts.count) people to the Event Members ? ")
        }
        .alert("Oops", isPresented: $viewModel.isAlertShowing) {
            Button("OK") {
                viewModel.addToEventMembers(personToAddGroup: viewModel.personToAddGroup, currentEvent: currentEvent)
                dismiss()
            }
        } message: {
            viewModel.alertMessage
        }
    }
    
    init(eventId: UUID) {
        let viewModel = ViewModel(eventId: eventId)
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Event.self, configurations: config)
        let example = Event()
        
        return NavigationStack{
            AddMemberView(eventId: example.id)

        }
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
