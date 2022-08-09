//
//  StudySettings.swift
//  Nursing
//
//  Created by Андрей Чернышев on 25.05.2022.
//

struct StudySettings: Codable, Hashable {
    private(set) var vibration: Bool
    private(set) var textSize: TextSize
}

// MARK: Public
extension StudySettings {
    static var `default`: StudySettings {
        StudySettings(vibration: true,
                      textSize: TextSize(percent: 100))
    }
    
    mutating func set(vibration: Bool) {
        self.vibration = vibration
    }
    
    mutating func set(textSize: TextSize) {
        self.textSize = textSize
    }
}
