//
//  LargeRateWidget.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 13.07.2021.
//

import SwiftUI
import WidgetKit

struct LargeRateWidget: Widget {
    let placeholder = StatsContent(date: Date(),
                                   passRate: 75,
                                   testTaken: CGFloat(80) / 100,
                                   testsTakenNum: 0,
                                   correctAnswers: CGFloat(76) / 100,
                                   correctAnswersNum: 0,
                                   questionsTaken: CGFloat(94) / 100,
                                   answeredQuestions: 0)
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "LargeRateWidget", provider: Provider(placeholder: placeholder)) { entry in 
            VStack(alignment: .leading) {
                ZStack() {
                    PassRateView(title: "Widgets.PassRate".localized,
                                 progressFontSize: 19.scale,
                                 progress: entry.passRate / 100,
                                 titleColor: Color.make(247, green: 250, blue: 255),
                                 progressColor: Color.make(247, green: 250, blue: 255))
                        .padding(EdgeInsets(top: 8.scale, leading: 16.scale, bottom: 0, trailing: 16.scale))
                }
                .cornerRadius(22.scale)
                .background(Color.make(88, green: 61, blue: 97))
                Spacer()
                HorizontalRateView(progress: entry.testTaken,
                                   title: "Widgets.TestsTaken".localized,
                                   titleColor: Color.make(19, green: 24, blue: 42),
                                   progressColor: Color.make(213, green: 77, blue: 91))
                    .padding(EdgeInsets(top: 4.scale, leading: 16.scale, bottom: 4.scale, trailing: 16.scale))
                Spacer()
                HorizontalRateView(progress: entry.correctAnswers,
                                   title: "Widgets.CorrectAnswers".localized,
                                   titleColor: Color.make(19, green: 24, blue: 42),
                                   progressColor: Color.make(88, green: 61, blue: 97))
                    .padding(EdgeInsets(top: 4.scale, leading: 16.scale, bottom: 4.scale, trailing: 16.scale))
                Spacer()
                HorizontalRateView(progress: entry.questionsTaken,
                                   title: "Widgets.QuestionsTaken".localized,
                                   titleColor: Color.make(19, green: 24, blue: 42),
                                   progressColor: Color.make(245, green: 174, blue: 120))
                    .padding(EdgeInsets(top: 4.scale, leading: 16.scale, bottom: 16.scale, trailing: 16.scale))
            }
        }
        .supportedFamilies([.systemLarge])
        .configurationDisplayName("Widgets.Large.Name".localized)
        .description("Widgets.Large.Description".localized)
    }
}
