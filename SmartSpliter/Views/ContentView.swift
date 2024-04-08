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
                        } description: {
                            Text("For now, you have no events, tap to add some")
                        }
                    }
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
