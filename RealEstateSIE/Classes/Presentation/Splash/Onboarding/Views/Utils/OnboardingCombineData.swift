//
//  OnboardingCombineDate.swift
//  ITExams
//
//  Created by Андрей Чернышев on 10.03.2022.
//

import Foundation

struct OCombineData {
    let motivation: OMotivationElement
    let age: String
    let exam: Exam
    let course: Course
    let examDate: Date?
    let studyMode: OStudyModeElement
    let testMinutes: Int
    let testDays: [DayOfWeek]
    let pushToken: String?
}

final class OnboardingCombineData {
    private var motivation: OMotivationElement?
    private var age: String?
    private var exam: Exam?
    private var course: Course?
    private var examDate: Date?
    private var studyMode: OStudyModeElement?
    private var testMinutes: Int?
    private var testDays: [DayOfWeek]?
    private var pushToken: String?
    
    func combineData() -> OCombineData? {
        guard
            let motivation = motivation,
            let age = age,
            let exam = exam,
            let course = course,
            let studyMode = studyMode,
            let testMinutes = testMinutes,
            let testDays = testDays
        else {
            return nil
        }
        
        return OCombineData(motivation: motivation,
                            age: age,
                            exam: exam,
                            course: course,
                            examDate: examDate,
                            studyMode: studyMode,
                            testMinutes: testMinutes,
                            testDays: testDays,
                            pushToken: pushToken)
    }
}

// MARK: OMotivationViewDelegate
extension OnboardingCombineData: OMotivationViewDelegate {
    func motivationViewDidSelected(element: OMotivationElement) {
        self.motivation = element
    }
}

// MARK: OAgeViewDelegate
extension OnboardingCombineData: OAgeViewDelegate {
    func ageViewDidSelected(age: String) {
        self.age = String(format: "Onboarding.CreatingPlanView.Years".localized, age)
    }
}

// MARK: OExamsViewDelegate
extension OnboardingCombineData: OExamsViewDelegate {
    func examsDidSelected(element: Exam) {
        exam = element
    }
}

// MARK: OCourseViewDelegate
extension OnboardingCombineData: OCourseViewDelegate {
    func courseViewDidSelected(course: Course) {
        self.course = course
    }
}

// MARK: OExamDateViewDelegate
extension OnboardingCombineData: OExamDateViewDelegate {
    func examDateDidSelected(date: Date?) {
        self.examDate = date
    }
}

// MARK: OStudyModeViewDelegate
extension OnboardingCombineData: OStudyModeViewDelegate {
    func studyModeViewDidSelected(element: OStudyModeElement) {
        self.studyMode = element
    }
}

// MARK: ODailyGoalViewDelegate
extension OnboardingCombineData: ODailyGoalViewDelegate {
    func dailyGoalDidSelected(testMinutes: Int) {
        self.testMinutes = testMinutes
    }
    
    func dailyGoalDidSelected(daysOfWeek: [DayOfWeek]) {
        self.testDays = daysOfWeek
    }
    
    func dailyGoalDidReceived(pushToken: String?) {
        self.pushToken = pushToken
    }
}
