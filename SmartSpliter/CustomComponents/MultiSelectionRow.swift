//
//  MultiSelectionRow.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import SwiftUI

import SwiftUI

struct MultiSelectionRow<Content: View>: View {
    
    typealias Action = () -> Void
    
    let id: UUID
    @Binding var selectedItems: Set<UUID>
    let content: Content
    var action: Action?
    
    var isSelected: Bool {
        selectedItems.contains(id)
    }
    var body: some View {
        HStack {
            content
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundStyle(Color.accentColor)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            //tap
            if isSelected {
                selectedItems.remove(id)
            } else {
                selectedItems.insert(id)
            }
            
            //action
            if let action = action {
                action()
            }
        }
    }
    
}
