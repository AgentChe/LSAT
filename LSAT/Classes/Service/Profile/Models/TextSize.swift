//
//  TextSize.swift
//  Nursing
//
//  Created by Андрей Чернышев on 25.05.2022.
//

import CoreGraphics

struct TextSize: Codable, Hashable {
    let percent: Int
    
    var questionFontSize: CGFloat {
        switch percent {
        case 80:
            return 16.scale
        case 90:
            return 18.scale
        case 100:
            return 20.scale
        case 110:
            return 22.scale
        case 120:
            return 24.scale
        default:
            return 20.scale
        }
    }
    
    var questionLineHeight: CGFloat {
        let fontSize = questionFontSize
        return (fontSize / 100) * 40 + fontSize
    }
    
    var answerFontSize: CGFloat {
        switch percent {
        case 80:
            return 13.scale
        case 90:
            return 15.scale
        case 100:
            return 17.scale
        case 110:
            return 19.scale
        case 120:
            return 21.scale
        default:
            return 17.scale
        }
    }
    
    var answerLineHeight: CGFloat {
        let fontSize = answerFontSize
        return (fontSize / 100) * 40 + fontSize
    }
}
