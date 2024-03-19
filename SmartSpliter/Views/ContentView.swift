//
//  ContentView.swift
//  SmartSpliter
//
//  Created by HubertMac on 19/03/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var events: [Event]
    
    @State private var path = [Event]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List{
                ForEach(events) { event in
                    NavigationLink(value: event){
                        VStack{
                            Text(event.eventName)
                            
                            Text(event.eventDate.formatted(date: .numeric, time:
                                    .omitted))
                        }
                    }
                }
                .onDelete(perform: deleteEvent)
            }
            .navigationTitle("Events")
            .navigationDestination(for: Event.self){ event in
                AddEditEventView(event: event)
            }
            .toolbar {
                Button("Add Event", systemImage: "plus", action: addEvent)
            }
        }
    }
    
    func addEvent() {
        let event = Event()
        modelContext.insert(event)
        path = [event]
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
}
