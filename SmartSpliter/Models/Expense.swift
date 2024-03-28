//
//  Expense.swift
//  SmartSpliter
//
//  Created by HubertMac on 19/03/2024.
//

import Foundation
import SwiftData

@Model
class Expense {
    var id = UUID()
    var expenseName: String
    var owner: ExpenseMember?
    var amount: Double
    var members: [ExpenseMember]
    @Relationship(inverse: \Event.expenses) var event: Event?
    
    init(
        expenseName: String = "",
        owner: ExpenseMember = ExpenseMember(person: Person()),
        amount: Double = 0, 
        members: [ExpenseMember] = [],
        event: Event? = nil)
    {
        self.expenseName = expenseName
        self.owner = owner
        self.amount = amount
        self.members = members
        self.event = event
    }
}
