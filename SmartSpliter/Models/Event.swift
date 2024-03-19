//
//  Event.swift
//  SmartSpliter
//
//  Created by HubertMac on 19/03/2024.
//

import Foundation
import SwiftData

@Model
class Event {
    var eventName: String
    var expenses:[Expense]?
    var eventMembers: [EventMember]?
    var eventDate: Date
    
    init(eventName: String = "", expenses: [Expense]? = nil, eventMembers: [EventMember]? = nil, eventDate: Date = .now) {
        self.eventName = eventName
        self.expenses = expenses
        self.eventMembers = eventMembers
        self.eventDate = eventDate
    }
}
