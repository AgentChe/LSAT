//
//  ColorExtension.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 19.07.2021.
//

import SwiftUI

extension Color {
    static func make(_ integralRed: Double, green: Double, blue: Double) -> Color {
        Color(red: integralRed / 255, green: green / 255, blue: blue / 255)
    }
}
