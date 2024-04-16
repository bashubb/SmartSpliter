//
//  AddNewPersonView.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import SwiftData
import SwiftUI

struct AddNewPersonView: View {
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel: ViewModel
    
    var onSave: (Person) -> Void
    
    @FocusState var isFocusedName
    @FocusState var isFocusedLastName
    @FocusState var isFocusedPhone
    
    var body: some View {
        // If adding new person show buttons: save and add to event
        VStack(spacing:0) {
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.red)
                        .shadow(color: Color.black, radius: 0.2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.red.opacity(0.4))
                        .clipShape(.rect(cornerRadius: 10))
                }
                
                Spacer()
                
                Button {
                    let newPerson = viewModel.createTotalyNewPerson()
                    onSave(newPerson)
                    router.path.removeLast(router.path.count - 1)
                } label : {
                    Text("Save and add to Event")
                        .foregroundStyle(viewModel.anyFieldEmpty ? .gray.opacity(0.2) : .green)
                        .shadow(color: Color.black, radius: 0.2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.green.opacity(0.4))
                        .background(viewModel.anyFieldEmpty ? .gray.opacity(0.2) : .green.opacity(0.3))
                        .clipShape(.rect(cornerRadius: 10))
                }
                .disabled(viewModel.anyFieldEmpty)
            }
            .buttonStyle(.plain)
            .padding()
            .padding(.horizontal)
            
            
            
            VStack(alignment: .leading) {
                Text("First Name")
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                TextField("type name", text: $viewModel.firstName)
                    .padding(10)
                    .font(.title3)
                    .focused($isFocusedName)
                    .background(.white, in: RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(isFocusedName ? Color.green : Color.gray, lineWidth: isFocusedName ? 2 : 1))
                
                Divider()
                
                Text("Last Name")
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                TextField("type last name", text: $viewModel.lastName)
                    .padding(10)
                    .font(.title3)
                    .focused($isFocusedLastName)
                    .background(.white, in: RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(isFocusedLastName ? Color.green : Color.gray, lineWidth: isFocusedLastName ? 2 : 1))
                
                Divider()
                
                Text("Phone Number")
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                TextField("type phone number", text: $viewModel.phoneNumber)
                    .padding(10)
                    .font(.title3)
                    .focused($isFocusedPhone)
                    .background(.white, in: RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(isFocusedPhone ? Color.green : Color.gray, lineWidth: isFocusedPhone ? 2 : 1))
            }
            .padding()
            .padding(.horizontal)
            Spacer()
        }
       
    }
    
    init(newPerson: Person, onSave:@escaping (Person) -> Void) {
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel(newPerson: newPerson))
        
    }
    

}




