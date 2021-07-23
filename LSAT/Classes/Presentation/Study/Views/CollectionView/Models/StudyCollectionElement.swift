//
//  StudyCollectionElement.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 30.01.2021.
//

struct StudyCollectionSection {
    let elements: [StudyCollectionElement]
}

enum StudyCollectionElement {
    case brief(SCEBrief)
    case takeTest(activeSubscription: Bool)
    case unlockAllQuestions
    case title(String)
    case mode(SCEMode)
}

struct SCEBrief {
    struct Day {
        let date: Date
        let activity: Bool
    }
    
    let courseName: String
    let streakDays: Int
    let calendar: [Day]
}

struct SCEMode {
    enum Mode {
        case today
        case ten
        case missed
        case random
    }
    
    let mode: Mode
    let image: String
    let title: String
}
