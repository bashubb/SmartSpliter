//
//  StringExtensions.swift
//  SmartSpliter
//
//  Created by HubertMac on 20/03/2024.
//

import Foundation

extension String {
    var isReallyEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension String {
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
