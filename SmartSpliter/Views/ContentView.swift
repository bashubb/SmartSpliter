//
//  ContentView.swift
//  SmartSpliter
//
//  Created by HubertMac on 19/03/2024.
//

import SwiftData
import SwiftUI


struct ContentView: View {
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) var modelContext
    @Query var events: [Event]
    
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                if events.isEmpty {
                    Button {
                        addEvent()
                    } label: {
                        ContentUnavailableView{
                            Label("No events", systemImage: "plus.square.dashed")
                                .foregroundColor(.blue)
                        } description: {
                            Text("For now, you have no events, tap to add some")
                        }
                    }
                    .buttonStyle(.plain)
                } else {
                    List{
                        Section("Events") {
                            ForEach(events) { event in
                                NavigationLink(value: event){
                                    VStack(alignment: .leading){
                                        Text(event.eventName)
                                            .font(.headline)
                                        Text(event.eventDate.formatted(date: .numeric, time:
                                                .omitted))
                                    }
                                }
                            }
                            .onDelete(perform: deleteEvent)
                        }
                    }
                }
            }
            .navigationTitle("SmartSpliter")
            .navigationDestination(for: Event.self){ event in
                AddEditEventView(event: event)
            }
            .navigationDestination(for: EventMember.self) { eventMember in
                EditMemberView(eventMember: eventMember)
            }
            .navigationDestination(for: Expense.self) { expense in
                AddEditExpenseView(expense: expense)
            }
            .navigationDestination(for: UUID.self) { id in
                AddMemberView(eventId: id)
            }
            .toolbar {
                if events.isNotEmpty {
                    Button("Add Event", systemImage: "plus", action: addEvent)
                }
            }
        }
        .fontDesign(.rounded)
    }
    
    func addEvent() {
        let event = Event()
        modelContext.insert(event)
        router.path.append(event)
    }
    
    
    func deleteEvent(_ indexSet: IndexSet) {
        for index in indexSet {
            let event = events[index]
            modelContext.delete(event)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Router())
}


enum NavigationType: String, Hashable {
    case editEvent = "Edit Event"
    case addMember = "Add Member"
    case addExpense = "Add Expense"
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
