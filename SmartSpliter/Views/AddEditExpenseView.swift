//
//  EditPersonView.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import SwiftData
import SwiftUI

struct AddEditExpenseView: View {
    @Bindable var expense: Expense
   
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: Event.self, configurations: config)
//        let event = Expense(owner: ExpenseMember(expenseAmount: 0, person: Person(id: <#T##UUID#>, firstName: <#T##String#>, lastName: <#T##String#>, phoneNumber: <#T##String#>), expense: <#T##Expense#>), amount: <#T##Double#>, members: <#T##[ExpenseMember]#>)(eventName: "Mountain Weekend")
//
//        return NavigationStack{
//            AddEditExpenseView(event: event, path: .constant(NavigationPath()))
//                .modelContainer(container)
//        }
//    } catch {
//        return Text("Failed to create container: \(error.localizedDescription)")
//    }
//}
