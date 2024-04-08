//
//  AddEditEventView.swift
//  SmartSpliter
//
//  Created by HubertMac on 19/03/2024.
//

import SwiftData
import SwiftUI

struct AddEditEventView: View {
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Bindable var event: Event
    
    @State private var isEditing = false
    @FocusState var isFoucused
    
    var backButtonHidden: Bool {
        if event.eventName.isReallyEmpty || ( isFoucused && event.eventName.isReallyEmpty) {
            return true
        }
        return false
    }
   
    
    var body: some View {
        List {
            // Summary of this event
            Section {
                TextField("Name", text: $event.eventName) { isEditing in
                    self.isEditing = isEditing
                }
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(isEditing ? Color.green : Color.gray, lineWidth: 2))
                .focused($isFoucused)
                
                DatePicker("Date", selection: $event.eventDate, displayedComponents: .date)
                    .labelsHidden()
                    
            } header: {
                HStack {
                    Text("Event Details")
                    Spacer()
                }
            }
            
            if event.eventMembers.isEmpty {
                Button {
                    addMembers()
                } label: {
                    ContentUnavailableView{
                        Label("No members", systemImage: "plus")
                    } description: {
                        Text("For now, you have no members in your event, tap to add some")
                    }
                }
            } else {
                Section {
                    // List of members - total amounts for person - delete posibility
                    ForEach(event.eventMembers) { eventMember in
                        NavigationLink(value: eventMember) {
                            VStack(alignment:.leading) {
                                HStack {
                                    Text(eventMember.person.firstName)
                                    Text(eventMember.person.lastName)
                                }
                                .font(.headline)
                                
                                Group {
                                    Text(eventMember.person.phoneNumber)
                                    Text(eventMember.wallet.formatted())
                                }
                                .font(.caption)
                            }
                        }
                    }
                    .onDelete(perform: deleteEventMember)
                } header: {
                    HStack {
                        Text("Event Members")
                        // Add some people from contacts or create
                        Spacer()
                        Button("Add some members", action: addMembers)
                            .buttonStyle(.bordered)
                    }
                }
            }
            
            
            if event.expenses.isEmpty {
                Button {
                    addExpense()
                } label: {
                    ContentUnavailableView{
                        Label("No expenses", systemImage: "plus")
                    } description: {
                        Text("For now, you have no expenses in your event, tap to add some")
                    }
                }
            } else {
                Section {
                    // List of expenses - delete possibility - expense detailView(choose who from members is contributing in this expense - list of members - removable, how to split?(equaly, fixed amount, summary? )
                    ForEach(event.expenses) { expense in
                        NavigationLink(value: expense) {
                            VStack {
                                Text(expense.expenseName)
                                Text("\(expense.amount.formatted())")
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text("Expenses")
                        // Add some people from contacts or create
                        Spacer()
                        Button("Add some expense", action: addExpense)
                            .buttonStyle(.bordered)
                        
                    }
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle("EditEvent")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(backButtonHidden)
        .toolbar {
            if backButtonHidden {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        modelContext.delete(event)
                        dismiss()
                    }
                }
            }
        }
        .onTapGesture{ isFoucused = false }
    }
    
    
    /// Functions
    func addMembers() {
        router.path.append(event.id)
    }
    
    func addExpense() {
        let expense = Expense()
        event.expenses.append(expense)
        router.path.append(expense)
    }
    
    func deleteExpense(_ indexSet: IndexSet) {
        for index in indexSet {
            let expense = event.expenses[index]
            modelContext.delete(expense)
        }
        event.expenses.remove(atOffsets: indexSet)
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
