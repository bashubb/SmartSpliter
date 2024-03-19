//
//  ExpenseMember.swift
//  SmartSpliter
//
//  Created by HubertMac on 19/03/2024.
//

import Foundation
import SwiftData

@Model
class ExpenseMember {
    var id = UUID()
    var expenseAmount: Double
    var person: Person
    var expense: Expense?
    
    init(expenseAmount: Double, person: Person, expense: Expense) {
        self.expenseAmount = expenseAmount
        self.person = person
        self.expense = expense
    }
}
