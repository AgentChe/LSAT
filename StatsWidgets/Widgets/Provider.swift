//
//  Provider.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let placeholder: StatsContent
    
    func placeholder(in context: Context) -> StatsContent {
        return placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (StatsContent) -> Void) {
        completion(placeholder)
    }

    func readContents() -> [Entry] {
        guard let stats = StatsShareManager.shared.read() else {
            return []
        }
    
        let content = StatsContent(passRate: CGFloat(stats.passRate),
                                   testTaken: CGFloat(stats.testTaken) / 100,
                                   testsTakenNum: stats.testsTakenNum,
                                   correctAnswers: CGFloat(stats.correctAnswers) / 100,
                                   correctAnswersNum: stats.correctAnswersNum,
                                   questionsTaken: CGFloat(stats.questionsTaken) / 100,
                                   answeredQuestions: stats.answeredQuestions)
        return [content]
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StatsContent>) -> Void) {
        let entries = readContents()
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
