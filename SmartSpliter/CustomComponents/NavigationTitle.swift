//
//  NavigationTitle.swift
//  SmartSpliter
//
//  Created by HubertMac on 16/04/2024.
//

import SwiftUI

struct NavigationTitle: View {
    var title: String
    var size: CGFloat
    
    var body: some View {
        Text(title)
            .font(.system(size: size))
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        
    }
}
