//
//  SmartSpliterApp.swift
//  SmartSpliter
//
//  Created by HubertMac on 19/03/2024.
//

import SwiftData
import SwiftUI

@main
struct SmartSpliterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Event.self)
        }
    }
}
