//
//  CoursesTableElement.swift
//  ITExams
//
//  Created by Андрей Чернышев on 26.04.2022.
//

import CoreGraphics

enum CoursesTableElement {
    case offset(CGFloat)
    case exam(CoursesTableExamElement)
    case course(CoursesTableCourseElement)
}

final class CoursesTableExamElement {
    let exam: Exam
    let courses: [CoursesTableCourseElement]
    var isOpened: Bool
    
    init(exam: Exam, courses: [CoursesTableCourseElement], isOpened: Bool) {
        self.exam = exam
        self.courses = courses
        self.isOpened = isOpened
    }
}

final class CoursesTableCourseElement {
    let course: Course
    var isCurrent: Bool
    var isSelected: Bool
    
    init(course: Course, isCurrent: Bool, isSelected: Bool) {
        self.course = course
        self.isCurrent = isCurrent
        self.isSelected = isSelected
    }
}
