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
            TextField("Type to filter", text: $filterString)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .focused($isTextFieldFocused)
            
            List(filteredItems, rowContent: content)
                .listStyle(.plain)
                .onAppear(perform: applyFilter)
                .onChange(of: filterString) { _ in
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

