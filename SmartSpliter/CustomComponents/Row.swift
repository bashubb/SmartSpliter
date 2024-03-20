//
//  Row.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import SwiftUI

struct Row: View {
    var contact: Contact
    
    var body: some View {
        VStack(alignment: .leading, spacing:3) {
            HStack {
                Text(contact.firstName)
                Text(contact.lastName)
            }
            .font(.headline)
            
            VStack(alignment: .leading) {
                ForEach(contact.phoneNumbers.components(separatedBy: ","), id:\.self){
                    Text($0.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
            .padding(.bottom, -10)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
    
}

#Preview {
    Row(contact:
    Contact(firstName: "Taylor", lastName: "Swift", phoneNumbers: "555-111-222"))
}
