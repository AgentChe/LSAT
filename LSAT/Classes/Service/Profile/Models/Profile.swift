//
//  Profile.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.05.2022.
//

import Foundation

struct Profile: Codable, Hashable {
    let testMode: TestMode?
    let testMinutes: Int?
    let examDate: Date?
    let selectedCourse: Course?
    let communityUrl: String?
}
