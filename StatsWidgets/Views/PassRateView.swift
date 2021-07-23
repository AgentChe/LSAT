//
//  PassRateView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import SwiftUI

struct PassRateView: View {
    let title: String
    let progressFontSize: CGFloat
    var progress: CGFloat
    let titleColor: Color
    let progressColor: Color
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 12.scale)
            
            HStack {
                Text(title)
                    .font(.system(size: 19.scale))
                    .foregroundColor(titleColor)
                Spacer()
                Text(String(format: "%.0f%%", min(self.progress, 1.0) * 100.0))
                    .font(.system(size: progressFontSize))
                    .fontWeight(.bold)
                    .foregroundColor(progressColor)
            }
            
            Spacer()
                .frame(height: 4.scale)
            
            LineProgressView(progress: progress, color: progressColor)
                .frame(height: 9.scale)
            
            Spacer(minLength: 20.scale)
        }
    }
}
