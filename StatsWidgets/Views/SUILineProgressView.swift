//
//  SUILineProgressView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import SwiftUI

struct LineProgressView: View {
    var progress: CGFloat
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.2)
                    .foregroundColor(color)
                    .cornerRadius(geometry.size.height / 2)
                
                Rectangle()
                    .frame(width: min(CGFloat(progress) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(color)
                    .cornerRadius(geometry.size.height / 2)
            }
        }
    }
}
