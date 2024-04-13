//
//  EventMember.swift
//  SmartSpliter
//
//  Created by HubertMac on 19/03/2024.
//

import Foundation
import SwiftData

@Model
class EventMember: Equatable, Hashable {
    var id = UUID()
    var wallet: Double
    var person: Person
    var event: Event
    
    init(wallet: Double = 0, person: Person = Person(), event: Event ) {
        self.wallet = wallet
        self.person = person
        self.event = event
    }
    
    static func ==(lhs: EventMember, rhs: EventMember) -> Bool {
        lhs.id == rhs.id
    }
 
}
