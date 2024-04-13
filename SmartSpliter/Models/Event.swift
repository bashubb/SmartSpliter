//
//  Event.swift
//  SmartSpliter
//
//  Created by HubertMac on 19/03/2024.
//

import Foundation
import SwiftData

@Model
class Event: Equatable {
    var id = UUID()
    var eventName: String
    var expenses: [Expense]
    var eventMembers: [EventMember]
    var eventDate: Date
    
    init(eventName: String = "", expenses: [Expense] = [], eventMembers: [EventMember] = [], eventDate: Date = .now) {
        self.eventName = eventName
        self.expenses = expenses
        self.eventMembers = eventMembers
        self.eventDate = eventDate
    }
    
    static func ==(lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id
    }
}
