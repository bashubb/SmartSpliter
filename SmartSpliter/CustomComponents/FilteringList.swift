//
//  FilteringList.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import SwiftUI

import SwiftUI

struct FilteringList<T: Identifiable, Content: View>: View {
    @State private var filteredItems = [T]()
    @State private var filterString = ""
    @FocusState private var isTextFieldFocused
    
    let listItems: [T]
    let filterKeyPaths: [KeyPath<T, String>]
    let content: (T) -> Content
    
    var body: some View {
        VStack {
            HStack {
                TextField("Type to filter", text: $filterString)
                    .padding(10)
                    .background(.white)
                    .focused($isTextFieldFocused)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(isTextFieldFocused ? Color.green : Color.gray, lineWidth: isTextFieldFocused ? 2 : 1))
                    .padding()
                    
                
                if  filterString.isNotEmpty {
                    Button {
                        filterString = ""
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.largeTitle)
                            .foregroundStyle(.gray.opacity(0.4))
                            .padding(.trailing)
                            .transition(.slide)
                            
                    }
                }
            }
            .animation(.spring, value: filterString)
            
            
            
            List(filteredItems, rowContent: content)
                .listStyle(.plain)
                .onAppear(perform: applyFilter)
                .onChange(of: filterString) { 
                    withAnimation {
                        applyFilter()
                    }
                }
                .onTapGesture {
                    isTextFieldFocused = false
                }
        }
        
    }
    
    init(_ data: [T], filterKeys: KeyPath<T, String>..., @ViewBuilder rowContent: @escaping (T) -> Content) {
        listItems =  data
        filterKeyPaths = filterKeys
        content = rowContent
    }
    
    func applyFilter() {
        let cleanedFilter = filterString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedFilter.isEmpty {
            filteredItems = listItems
        } else {
            filteredItems = listItems.filter { element in
                filterKeyPaths.contains {
                    element[keyPath: $0]
                        .localizedCaseInsensitiveContains(cleanedFilter)
                }
            }
        }
    }
}

