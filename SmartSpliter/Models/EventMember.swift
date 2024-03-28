//
//  EventMember.swift
//  SmartSpliter
//
//  Created by HubertMac on 19/03/2024.
//

import Foundation
import SwiftData

@Model
class EventMember: Hashable {
    var id = UUID()
    var wallet: Double
    var person: Person
    var event: Event
    
    init(eventAmount: Double = 0, person: Person = Person(), event: Event ) {
        self.wallet = eventAmount
        self.person = person
        self.event = event
    }
}
