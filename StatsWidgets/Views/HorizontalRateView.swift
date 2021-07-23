//
//  HorizontalRateView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import SwiftUI

struct HorizontalRateView: View {
    let progress: CGFloat
    let title: String
    let titleColor: Color
    let progressColor: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 16.scale))
                    .fontWeight(.semibold)
                    .foregroundColor(titleColor)
                Text(String(format: "%.0f%%", min(self.progress, 1.0) * 100.0))
                    .font(.system(size: 40.scale))
                    .fontWeight(.bold)
                    .foregroundColor(progressColor)
            }
            Spacer()
            SUICircleView(progress: progress, color: progressColor)
                .frame(width: 59.scale, height: 59.scale, alignment: .trailing)
        }
    }
}
