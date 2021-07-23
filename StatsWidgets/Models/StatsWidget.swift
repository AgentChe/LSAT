//
//  StatsWidget.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import SwiftUI
import WidgetKit

struct StatsContent: TimelineEntry {
    var date = Date()
    let passRate: CGFloat
    let testTaken: CGFloat
    let testsTakenNum: Int
    let correctAnswers: CGFloat
    let correctAnswersNum: Int
    let questionsTaken: CGFloat
    let answeredQuestions: Int
}
