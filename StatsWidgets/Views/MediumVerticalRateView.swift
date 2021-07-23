//
//  MediumVerticalRateView.swift
//  StatsWidgetsExtension
//
//  Created by Vitaliy Zagorodnov on 12.07.2021.
//

import WidgetKit
import SwiftUI

struct MediumVerticalRateView: View {
    @State var count: Int
    @State var title: String
    @State var color: Color
    
    @Environment(\.colorScheme) var colorScheme
    
    var titleColor: Color {
        colorScheme == .dark
            ? Color.make(247, green: 250, blue: 255)
            : Color.make(213, green: 77, blue: 91)
    }
    
    var body: some View {
        VStack {
            Text("\(count)")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .foregroundColor(color)
            Spacer(minLength: 2)
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(titleColor)
        }
    }
}
