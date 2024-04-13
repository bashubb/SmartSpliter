//
//  Person.swift
//  SmartSpliter
//
//  Created by HubertMac on 19/03/2024.
//

import Foundation
import SwiftData

@Model
class Person: Equatable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var phoneNumber: String
    @Relationship (inverse: \EventMember.person) var eventMembers: [EventMember]
    
    init(id: UUID = UUID(), firstName: String = "", lastName: String = "", phoneNumber: String = "", eventMembers: [EventMember] = []) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.eventMembers = eventMembers
    }
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }
    
    
    #if DEBUG
    static let example = Person(firstName: "John", lastName: "Smith")
    #endif
}
