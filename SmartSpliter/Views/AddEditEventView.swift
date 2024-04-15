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
    
    @FocusState var isFoucused
    @State private var isChevronSpining = false
    @State private var isSummaryExpanded = false
    @State private var showSummaryContent = false
    @State private var isEditing = false
    @State private var nameEdit = false
    
    @Namespace var namespace
    
    
    var backButtonHidden: Bool {
        if event.eventName.isReallyEmpty || ( isFoucused && event.eventName.isReallyEmpty) {
            return true
        }
        return false
    }
    
    
    var body: some View {
        ZStack {
            VStack(spacing:0){
                // Summary of this event
                
                VStack(spacing:0) {
                    VStack(spacing:14) {
                        VStack(alignment: .leading) {
                            Text("Event Name:")
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                            HStack {
                                TextField("Name", text: $event.eventName)
                                    .padding(10)
                                    .font(.title3)
                                    .focused($isFoucused)
                                
                                if  event.eventName.isNotEmpty {
                                    Button {
                                        event.eventName = ""
                                    } label: {
                                        Image(systemName: "xmark.square")
                                            .font(.title)
                                            .foregroundStyle(.gray.opacity(0.4))
                                    }
                                    .padding(.trailing, 3)
                                }
                            }
                            .background(.white)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(isFoucused ? Color.green : Color.gray, lineWidth: isFoucused ? 2 : 1))
                            .animation(.spring(response: 0.4), value: event.eventName)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            Text("Event Date:")
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                            
                            DatePicker("Event Date:" ,selection: $event.eventDate, displayedComponents: .date)
                                .labelsHidden()
                                .background(RoundedRectangle(cornerRadius: 8, style : .continuous).fill(Color.blue).opacity(0.2))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(.bar)
                        .shadow(color: .gray, radius: 0.5))
                    .padding(.bottom, 10)
                    
                    
                    if isSummaryExpanded {
                        VStack {
                            HStack {
                                Image(systemName: "dollarsign.circle")
                                    .font(.largeTitle)
                                    .foregroundStyle(.orange)
                                Text("Event Summary")
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.title)
                                    .rotationEffect(isChevronSpining ? Angle(degrees: 180) : Angle(degrees: 0))
                            }
                            .onTapGesture {
                                withAnimation {
                                    isChevronSpining.toggle()
                                }
                                withAnimation {
                                    showSummaryContent.toggle()
                                } completion: {
                                    withAnimation {
                                        isSummaryExpanded.toggle()
                                    }
                                }
                            }
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    Button {
                                        // share summary
                                    } label: {
                                        Label("share", systemImage: "square.and.arrow.up")
                                    }
                                    .buttonStyle(.bordered)
                                }
                                Text("Event Summary here")
                            }
                            .opacity(showSummaryContent ? 1 : 0)
                        }
                        .padding(7)
                        .background(RoundedRectangle(cornerRadius: 8).fill(.bar)
                            .shadow(color: .gray, radius: 0.5)
                            .matchedGeometryEffect(id: "summary", in: namespace))
                    } else {
                        VStack {
                            HStack {
                                Image(systemName: "dollarsign.circle")
                                    .font(.largeTitle)
                                    .foregroundStyle(.orange)
                                Text("Event Summary")
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.title)
                                    .rotationEffect(isChevronSpining ? Angle(degrees: 180) : Angle(degrees: 0))
                            }
                            .onTapGesture {
                                withAnimation {
                                    isSummaryExpanded.toggle()
                                } completion : {
                                    withAnimation {
                                        showSummaryContent.toggle()
                                    }
                                    withAnimation {
                                        isChevronSpining.toggle()
                                    }
                                }
                            }
                            
                        }
                        .padding(7)
                        .background(RoundedRectangle(cornerRadius: 8).fill(.bar)
                            .shadow(color: .gray, radius: 0.5)
                            .matchedGeometryEffect(id: "summary", in: namespace))
                    }
                }
                .padding(8)
                
                
                List {
                    Section {
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
                        }
                        
                    } header: {
                        HStack {
                            Text("Event Members")
                                .font(.headline.bold())
                                .textCase(.uppercase)
                            // Add some people from contacts or create
                            Spacer()
                            if event.eventMembers.isNotEmpty {
                                Button{
                                    addMembers()
                                } label: {
                                    HStack{
                                        Image(systemName:"plus")
                                        Image(systemName: "person.fill")
                                    }
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                    
                    Section {
                        // List of expenses - delete possibility - expense detailView(choose who from members is contributing in this expense - list of members - removable, how to split?(equaly, fixed amount, summary? )
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
                            ForEach(event.expenses) { expense in
                                NavigationLink(value: expense) {
                                    VStack {
                                        Text(expense.expenseName)
                                        Text("\(expense.amount.formatted())")
                                    }
                                }
                            }
                            .onDelete(perform: deleteExpense)
                        }
                    } header: {
                        HStack {
                            Text("Expenses")
                                .font(.headline.bold())
                                .textCase(.uppercase)
                            // Add some people from contacts or create
                            Spacer()
                            if event.expenses.isNotEmpty {
                                Button{
                                    addExpense()
                                } label: {
                                    HStack {
                                        Image(systemName: "plus")
                                        Image(systemName: "dollarsign.circle")
                                    }
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                    
                }
                .scrollIndicators(.hidden)
                .background(Rectangle().stroke(.bar)
                    .shadow(color: .gray, radius: 0.5))
                .padding(.top, 10)
            }
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
        .listStyle(.plain)
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




//if event.eventName.isEmpty {

//}
