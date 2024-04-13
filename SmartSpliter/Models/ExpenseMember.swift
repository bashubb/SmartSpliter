//
//  ExpenseMember.swift
//  SmartSpliter
//
//  Created by HubertMac on 19/03/2024.
//

import Foundation
import SwiftData

@Model
class ExpenseMember: Equatable {
    var id = UUID()
    var expenseAmount: Double
    var person: Person
    var expense: Expense?
    
    init(expenseAmount: Double = 0, person: Person = Person(), expense: Expense? = nil) {
        self.expenseAmount = expenseAmount
        self.person = person
        self.expense = expense
    }
    
    static func ==(lhs: ExpenseMember, rhs: ExpenseMember) -> Bool {
        lhs.id == rhs.id
    }
}
