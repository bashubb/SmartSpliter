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
        VStack(spacing:0){
            // Summary of this event
            
            VStack {
                HStack {
                    Text("Event Name:")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    TextField("Name", text: $event.eventName) { isEditing in
                        self.isEditing = isEditing
                    }
                    .padding(10)
                    .background(.white)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(isEditing ? Color.green : Color.gray, lineWidth: isFoucused ? 2 : 1))
                    .focused($isFoucused)
                    
                }
                DatePicker("Event Date:" ,selection: $event.eventDate, displayedComponents: .date)
                    .font(.footnote)
                    .fontWeight(.semibold)
            }
            .padding()
            .background(.bar)
            
            List {
                if event.eventMembers.isEmpty {
                    Button {
                        addMembers()
                    } label: {
                        ContentUnavailableView{
                            Label("No members", systemImage: "plus")
                                .foregroundStyle(.blue)
                        } description: {
                            Text("For now, you have no members in your event, tap to add some")
                        }
                    }
                    .padding(.vertical, 30)
                    .buttonStyle(.plain)
                } else {
                    Section {
                        ForEach(event.eventMembers) { eventMember in
                            HStack{
                                Text(eventMember.person.firstName)
                                Text(eventMember.person.lastName)
                            }
                            .font(.headline)
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                NavigationLink(value: eventMember) {
                                    Image(systemName: "pencil")
                                }
                                .tint(.orange)
                            }
                            .padding()
                            
                        }
                        .onDelete(perform: deleteEventMember)
                        .listRowInsets(EdgeInsets())
                    } header: {
                        HStack {
                            Text("Event Members")
                                .font(.headline.bold())
                                .textCase(.uppercase)
                            // Add some people from contacts or create
                            Spacer()
                            Button("Add some members", action: addMembers)
                                .buttonStyle(.bordered)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                if event.expenses.isEmpty {
                    Button {
                        addExpense()
                    } label: {
                        ContentUnavailableView{
                            Label("No expenses", systemImage: "plus")
                                .foregroundStyle(.blue)
                        } description: {
                            Text("For now, you have no expenses in your event, tap to add some")
                        }
                    }
                    .buttonStyle(.plain)
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
                        .onDelete(perform: deleteExpense)
                    } header: {
                        HStack {
                            Text("Expenses")
                                .font(.headline.bold())
                                .textCase(.uppercase)
                            // Add some people from contacts or create
                            Spacer()
                            Button("Add some expense", action: addExpense)
                                .buttonStyle(.bordered)
                            
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .ignoresSafeArea(.keyboard)
        .navigationTitle("Event Details")
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
        .onTapGesture(count: 2){
            isFoucused = false
        }
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
        let example = Event(eventName: "Mountain Weekend")
        
        return NavigationStack{
            AddEditEventView(event: example)
                .modelContainer(container)
        }
        .listStyle(.grouped)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}

//struct EventMemberCardView: View {
//    var eventMember: EventMember
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                VStack(alignment: .leading) {
//                    Group {
//                        Text(eventMember.person.firstName) +
//                        Text(eventMember.person.lastName)
//                    }
//                    .font(.headline)
//
//                    Group {
//                        Text(eventMember.person.phoneNumber)
//                        Text(eventMember.wallet.formatted())
//                    }
//                    .font(.caption)
//                }
//
//                Spacer()
//
//                VStack {
//                    NavigationLink(value: eventMember) {
//                        Image(systemName: "pencil")
//                            .font(.title)
//                    }
//                    .buttonStyle(.bordered)
//                    .tint(.yellow)
//
//                    Button{
//
//                    } label: {
//                        Image(systemName: "trash")
//                            .font(.title)
//
//                    }
//                    .buttonStyle(.bordered)
//                    .tint(.red.opacity(0.3))
//
//                }
//            }
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding()
//        .containerRelativeFrame(.horizontal)
//        .background(.bar)
//        .clipShape(RoundedRectangle(cornerRadius: 10))
//        .shadow(radius: 2)
//        .padding(4)
//


