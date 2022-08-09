//
//  ProfileManager.swift
//  FNP
//
//  Created by Andrey Chernyshev on 09.07.2021.
//

import RxSwift
import Foundation

protocol ProfileManagerProtocol {
    func set(examDate: Date?,
             course: Course?,
             testMode: TestMode?,
             testMinutes: Int?,
             testNumber: Int?,
             testWhen: [Int]?,
             notificationKey: String?) -> Single<Void>
    func set(vibration: Bool) -> Single<Void>
    func set(selectedTextSize: TextSize) -> Single<Void>
    func obtainStudySettings() -> Single<StudySettings>
    func obtainProfile(forceUpdate: Bool) -> Single<Profile?>
    func obtainDateOfExam(forceUpdate: Bool) -> Single<Date?>
    func obtainSelectedCourse(forceUpdate: Bool) -> Single<Course?>
    func obtainTestMode(forceUpdate: Bool) -> Single<TestMode?>
    func obtainTestMinutes(forceUpdate: Bool) -> Single<Int?>
    func syncTokens(oldToken: String, newToken: String) -> Single<Void>
    func login(userToken: String) -> Single<Void>
}

final class ProfileManager: ProfileManagerProtocol {
    enum Constants {
        static let studySettingsKey = "profile_manager_study_settings"
        static let dateOfExamKey = "profile_manager_date_of_exam_key"
        static let courseKey = "profile_manager_course_key"
        static let testModeKey = "profile_manager_test_mode_key"
        static let testMinutesKey = "profile_manager_test_minutes_key"
        static let communityUrlKey = "profile_manager_community_url_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: Study
extension ProfileManager {
    func set(examDate: Date? = nil,
             course: Course? = nil,
             testMode: TestMode? = nil,
             testMinutes: Int? = nil,
             testNumber: Int? = nil,
             testWhen: [Int]? = nil,
             notificationKey: String? = nil) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SetRequest(userToken: userToken,
                                 examDate: examDateStringFormatted(examDate),
                                 courseId: course?.id,
                                 testMode: testMode?.code(),
                                 testMinutes: testMinutes,
                                 testNumber: testNumber,
                                 testWhen: testWhen,
                                 notificationKey: notificationKey)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.store(dateOfExam: examDate)
                self.store(course: course)
                self.store(testMode: testMode)
                self.store(testMinutes: testMinutes)
            })
    }
    
    func set(vibration: Bool) -> Single<Void> {
        Single<Void>.create { event in
            var studySettings: StudySettings
            
            if let data = UserDefaults.standard.data(forKey: Constants.studySettingsKey),
               let cached = try? JSONDecoder().decode(StudySettings.self, from: data) {
                studySettings = cached
            } else {
                studySettings = StudySettings.default
            }
            
            studySettings.set(vibration: vibration)
            
            if let data = try? JSONEncoder().encode(studySettings) {
                UserDefaults.standard.set(data, forKey: Constants.studySettingsKey)
            }
            
            event(.success(Void()))
            
            return Disposables.create()
        }
    }
    
    func set(selectedTextSize: TextSize) -> Single<Void> {
        Single<Void>.create { event in
            var studySettings: StudySettings
            
            if let data = UserDefaults.standard.data(forKey: Constants.studySettingsKey),
               let cached = try? JSONDecoder().decode(StudySettings.self, from: data) {
                studySettings = cached
            } else {
                studySettings = StudySettings.default
            }
            
            studySettings.set(textSize: selectedTextSize)
            
            if let data = try? JSONEncoder().encode(studySettings) {
                UserDefaults.standard.set(data, forKey: Constants.studySettingsKey)
            }
            
            event(.success(Void()))
            
            return Disposables.create()
        }
    }
    
    func obtainStudySettings() -> Single<StudySettings> {
        Single<StudySettings>.create { event in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.studySettingsKey),
                let studySettings = try? JSONDecoder().decode(StudySettings.self, from: data)
            else {
                event(.success(StudySettings.default))
                return Disposables.create()
            }
            
            event(.success(studySettings))
            
            return Disposables.create()
        }
    }
    
    func obtainProfile(forceUpdate: Bool) -> Single<Profile?> {
        forceUpdate ? loadProfile() : cachedProfile()
    }
    
    func obtainDateOfExam(forceUpdate: Bool) -> Single<Date?> {
        forceUpdate ? loadDateOfExam() : cachedDateOfExam()
    }
    
    func obtainSelectedCourse(forceUpdate: Bool) -> Single<Course?> {
        forceUpdate ? loadSelectedCourse() : cachedSelectedCourse()
    }
    
    func obtainTestMode(forceUpdate: Bool) -> Single<TestMode?> {
        forceUpdate ? loadTestMode() : cachedTestMode()
    }
    
    func obtainTestMinutes(forceUpdate: Bool) -> Single<Int?> {
        forceUpdate ? loadTestMinutes() : cachedTestMinutes()
    }
    
    func syncTokens(oldToken: String, newToken: String) -> Single<Void> {
        let request = SyncTokensRequest(oldToken: oldToken, newToken: newToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func login(userToken: String) -> Single<Void> {
        defaultRequestWrapper
            .callServerApi(requestBody: LoginRequest(userToken: userToken))
            .mapToVoid()
    }
}

// MARK: Private
private extension ProfileManager {
    func cachedProfile() -> Single<Profile?> {
        let testMode = cachedTestMode()
        let testMinutes = cachedTestMinutes()
        let examDate = cachedDateOfExam()
        let selectedCourse = cachedSelectedCourse()
        let communityUrl = cachedCommunityUrl()
        
        return Single
            .zip(
                testMode,
                testMinutes,
                examDate,
                selectedCourse,
                communityUrl
            ) { testMode, testMinutes, examDate, selectedCourse, communityUrl -> Profile in
                Profile(testMode: testMode,
                        testMinutes: testMinutes,
                        examDate: examDate,
                        selectedCourse: selectedCourse,
                        communityUrl: communityUrl)
            }
    }
    
    func loadProfile() -> Single<Profile?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetProfileRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetProfileResponseMapper.map(from: $0) }
            .do(onSuccess: { [weak self] profile in
                guard let self = self, let profile = profile else {
                    return
                }
                
                self.store(testMode: profile.testMode)
                self.store(testMinutes: profile.testMinutes)
                self.store(dateOfExam: profile.examDate)
                self.store(course: profile.selectedCourse)
                self.store(communityUrl: profile.communityUrl)
            })
    }
    
    func store(dateOfExam: Date?) {
        guard let dateOfExam = dateOfExam else {
            return
        }
        
        UserDefaults.standard.set(dateOfExam, forKey: Constants.dateOfExamKey)
        
        ProfileMediator.shared.notifyAboutChanged(dateOfExam: dateOfExam)
    }
    
    func cachedDateOfExam() -> Single<Date?> {
        Single<Date?>
            .create { event in
                guard let dateOfExam = UserDefaults.standard.value(forKey: Constants.dateOfExamKey) as? Date else {
                    event(.success(nil))
                    return Disposables.create()
                }
                
                event(.success(dateOfExam))
                
                return Disposables.create()
            }
    }
    
    func loadDateOfExam() -> Single<Date?> {
        loadProfile()
            .map { $0?.examDate }
            .do(onSuccess: { [weak self] dateOfExam in
                guard let self = self, let dateOfExam = dateOfExam else {
                    return
                }
                
                self.store(dateOfExam: dateOfExam)
            })
    }
    
    func store(course: Course?) {
        guard let course = course, let data = try? JSONEncoder().encode(course) else {
            return
        }
        
        UserDefaults.standard.set(data, forKey: Constants.courseKey)
        
        ProfileMediator.shared.notifyAboutChanged(course: course)
    }
    
    func cachedSelectedCourse() -> Single<Course?> {
        Single<Course?>
            .create { event in
                guard let data = UserDefaults.standard.data(forKey: Constants.courseKey) else {
                    event(.success(nil))
                    return Disposables.create()
                }
                
                let course = try? JSONDecoder().decode(Course.self, from: data)
                
                event(.success(course))
                
                return Disposables.create()
            }
    }
    
    func loadSelectedCourse() -> Single<Course?> {
        loadProfile()
            .map { $0?.selectedCourse }
            .do(onSuccess: { [weak self] course in
                guard let self = self, let course = course else {
                    return
                }
                
                self.store(course: course)
            })
    }
    
    func store(testMode: TestMode?) {
        guard let testMode = testMode, let data = try? JSONEncoder().encode(testMode) else {
            return
        }
        
        UserDefaults.standard.set(data, forKey: Constants.testModeKey)
        
        ProfileMediator.shared.notifyAboutChanged(testMode: testMode)
    }
    
    func cachedTestMode() -> Single<TestMode?> {
        Single<TestMode?>
            .create { event in
                guard
                    let data = UserDefaults.standard.data(forKey: Constants.testModeKey),
                    let mode = try? JSONDecoder().decode(TestMode.self, from: data)
                else {
                    event(.success(nil))
                    return Disposables.create()
                }

                event(.success(mode))
                
                return Disposables.create()
            }
    }
    
    func loadTestMode() -> Single<TestMode?> {
        loadProfile()
            .map { $0?.testMode }
            .do(onSuccess: { [weak self] testMode in
                guard let self = self, let testMode = testMode else {
                    return
                }
                
                self.store(testMode: testMode)
            })
    }
    
    func store(testMinutes: Int?) {
        guard let testMinutes = testMinutes else {
            return
        }

        UserDefaults.standard.set(testMinutes, forKey: Constants.testMinutesKey)
        
        ProfileMediator.shared.notifyAboutChanged(testMinutes: testMinutes)
    }
    
    func cachedTestMinutes() -> Single<Int?> {
        Single<Int?>
            .create { event in
                guard let testMinutes = UserDefaults.standard.value(forKey: Constants.testMinutesKey) as? Int else {
                    event(.success(nil))
                    return Disposables.create()
                }
                
                event(.success(testMinutes))
                
                return Disposables.create()
            }
    }
    
    func loadTestMinutes() -> Single<Int?> {
        loadProfile()
            .map { $0?.testMinutes }
            .do(onSuccess: { [weak self] testMinutes in
                guard let self = self, let testMinutes = testMinutes else {
                    return
                }
                
                self.store(testMinutes: testMinutes)
            })
    }
    
    func store(communityUrl: String?) {
        UserDefaults.standard.set(communityUrl, forKey: Constants.communityUrlKey)
    }
    
    func cachedCommunityUrl() -> Single<String?> {
        Single<String?>.create { event in
            let communityUrl = UserDefaults.standard.string(forKey: Constants.communityUrlKey)
            
            event(.success(communityUrl))
            
            return Disposables.create()
        }
    }
    
    func examDateStringFormatted(_ date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale.current
        
        return formatter.string(from: date)
    }
}
