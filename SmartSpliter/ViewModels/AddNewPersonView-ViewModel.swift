//
//  AddNewPersonView-ViewModel.swift
//  SmartSpliter
//
//  Created by HubertMac on 16/04/2024.
//

import Foundation

extension AddNewPersonView {
    
    @Observable
    class ViewModel {
        
        var firstName: String
        var lastName: String
        var phoneNumber: String
        var newPerson: Person
        
        var anyFieldEmpty: Bool {
            firstName.isEmpty || phoneNumber.isEmpty
        }
        
        init(newPerson: Person) {
            self.firstName = newPerson.firstName
            self.lastName = newPerson.lastName
            self.phoneNumber = newPerson.phoneNumber
            self.newPerson = newPerson
        }
       
        func createTotalyNewPerson() -> Person {
            let newPerson = self.newPerson
            newPerson.id = UUID()
            newPerson.firstName = firstName
            newPerson.lastName = lastName
            newPerson.phoneNumber = phoneNumber
            return newPerson
        }
    }
                        
}
