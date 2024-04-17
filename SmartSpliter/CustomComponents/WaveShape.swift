//
//  WaveShape.swift
//  SmartSpliter
//
//  Created by HubertMac on 16/04/2024.
//

import Foundation
import SwiftUI

struct Wave: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY),                  control1: CGPoint(x: rect.midX * 1.25,
                                        y:rect.maxY * 0.7),
                      control2: CGPoint(x: rect.midX * 0.75,
                                        y: rect.maxY * 1.3))
        path.closeSubpath()
        
        return path
    }
}
