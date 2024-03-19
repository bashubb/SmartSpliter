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
    var expenseName: String
    var owner: ExpenseMember
    var amount: Double
    var members: [ExpenseMember]
    
    init(expenseName: String, owner: ExpenseMember, amount: Double, members: [ExpenseMember]) {
        self.expenseName = expenseName
        self.owner = owner
        self.amount = amount
        self.members = members
    }
}
