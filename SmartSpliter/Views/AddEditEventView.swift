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
    
    @FocusState var isFocused
    @State private var isChevronSpining = false
    @State private var isSummaryExpanded = false
    @State private var showSummaryContent = false
    
    @State var isEditing = false
    @State var showEditingUI = false
    
    @State private var nameEdit = false
    
    @Namespace var namespace
    
    
    var backButtonHidden: Bool {
        if event.eventName.isReallyEmpty || ( isFocused && event.eventName.isReallyEmpty) {
            return true
        }
        return false
    }
    
    
    var body: some View {
        ZStack {
            if $isEditing.wrappedValue {
                ZStack{
                    Color.black
                        .opacity(0.4)
                        .ignoresSafeArea()
                    VStack {
                        EditDetailsView(event: event, isEditing: $isEditing, showEditingUI: $showEditingUI)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(.bar)
                                .stroke(.gray.opacity(0.5)).matchedGeometryEffect(id: "edit", in: namespace))
                            .padding(20)
                        Spacer()
                    }
                }
                .zIndex(1)
            }
            
            VStack(spacing:0){
                Wave()
                    .fill(.gray.opacity(0.1))
                    .frame(height: 200)
                    .overlay(Wave()
                        .fill(Color.blue.opacity(0.2))
                        .scaleEffect(x: -1))
//                    .overlay(NavigationTitle(title: "Manage Your Event", size: 35)
//                        .padding([.top,.leading], 20))
                    .padding(.bottom)
                VStack(spacing: 14){
                    
                    ZStack(alignment: .topTrailing) {
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Event Name:")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            
                            Text(event.eventName)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Divider()
                                .padding(.bottom,3)
                            
                            Text("Event date:")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            
                            Text(event.eventDate, style: .date)
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(RoundedRectangle(cornerRadius:8).fill(.white)
                            .shadow(radius: 0.2))
                        
                        Button {
                            withAnimation(.spring.speed(1.5)){
                                isEditing.toggle()
                            } completion: {
                                withAnimation(.spring.speed(1.5)) {
                                    showEditingUI.toggle()
                                }
                            }
                        } label: {
                            Image(systemName: "pencil")
                                .font(.title).bold()
                                .padding(9)
                                .background(Capsule().fill(.ultraThickMaterial)
                                    .matchedGeometryEffect(id: "edit", in: namespace))
                        }
                        
                        .padding(7)
                    }
                    
                    if isSummaryExpanded {
                        VStack {
                            Button{
                                withAnimation(.spring.speed(1.5)) {
                                    isChevronSpining.toggle()
                                }
                                withAnimation(.spring.speed(1.5)) {
                                    showSummaryContent.toggle()
                                } completion: {
                                    withAnimation(.spring.speed(1.5)) {
                                        isSummaryExpanded.toggle()
                                    }
                                }
                            } label: {
                                HStack {
                                    Text("Hide Summary")
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .font(.title)
                                        .rotationEffect(isChevronSpining ? Angle(degrees: 180) : Angle(degrees: 0))
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
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(.blue.opacity(0.05))
                            .matchedGeometryEffect(id: "summary", in: namespace)
                            .shadow(radius: 0.2))
                        
                    } else {
                        VStack {
                            Button {
                                
                                    withAnimation(.spring.speed(1.5)) {
                                        isSummaryExpanded.toggle()
                                    } completion : {
                                        withAnimation(.spring.speed(1.5)) {
                                            showSummaryContent.toggle()
                                        }
                                        withAnimation(.spring.speed(1.5)) {
                                            isChevronSpining.toggle()
                                        }
                                    }
                            } label: {
                                HStack {
                                    Text("Show summary")
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .font(.title)
                                        .rotationEffect(isChevronSpining ? Angle(degrees: 180) : Angle(degrees: 0))
                                }
                            }
                            
                            
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(.blue.opacity(0.05))
                            .matchedGeometryEffect(id: "summary", in: namespace)
                            .shadow(radius: 0.2))
                    }
                }
                .padding()
                
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
                
            }
            .edgesIgnoringSafeArea(.top)
        }
        .ignoresSafeArea(.keyboard)
        .navigationTitle("Manage your event")
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
            isFocused = false
        }
        .background(.bar)
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

struct EditDetailsView: View {
    @Bindable var event: Event
    @FocusState var isFocused
    @Binding var isEditing: Bool
    @Binding var showEditingUI: Bool
    
    @State private var name = ""
    @State private var date = Date.now
    var body: some View {
        VStack(spacing:14) {
            HStack{
                Button{
                    closingAnimation()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.red)
                        .shadow(color: Color.black, radius: 0.2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.red.opacity(0.2))
                        .clipShape(.rect(cornerRadius: 10))
                }
                
                Button{
                    event.eventName = name
                    event.eventDate = date
                    closingAnimation()
                } label: {
                    Text("Save")
                        .foregroundStyle(name.isEmpty ? .gray.opacity(0.2) : .green)
                        .shadow(color: Color.black, radius: 0.2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(name.isEmpty ? .gray.opacity(0.2) : .green.opacity(0.3))
                        .clipShape(.rect(cornerRadius: 10))
                }
            }
            .buttonStyle(.plain)
            .padding(.top, 20)
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("Event Name:")
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                HStack {
                    TextField("Name", text: $name)
                        .padding(10)
                        .font(.title3)
                        .focused($isFocused)
                    
                    if  name.isNotEmpty {
                        Button {
                            name = ""
                        } label: {
                            Image(systemName: "xmark.circle")
                                .font(.title)
                                .foregroundStyle(.gray.opacity(0.4))
                            
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 3)
                    }
                }
                .background(.white, in: RoundedRectangle(cornerRadius:10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(isFocused ? Color.green : Color.gray, lineWidth: isFocused ? 2 : 1))
            }
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("Event Date:")
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                DatePicker("Event Date:" ,selection: $date, displayedComponents: .date)
                    .labelsHidden()
                    .background(RoundedRectangle(cornerRadius: 8, style : .continuous).fill(Color.blue).opacity(0.2))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            name = event.eventName
            date = event.eventDate
        }
        .padding()
        .opacity(showEditingUI ? 1 : 0)
        
    }
    
    func closingAnimation() {
        withAnimation {
            showEditingUI.toggle()
        }
        withAnimation(.snappy(extraBounce: 0.1).delay(0.2)) {
            isEditing.toggle()
        }
    }
}
