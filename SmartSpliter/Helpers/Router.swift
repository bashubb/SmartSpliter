//
//  Router.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import SwiftUI


class Router: ObservableObject {
   @Published var path = NavigationPath()
    
    func reset() {
        path = NavigationPath()
    }
}
