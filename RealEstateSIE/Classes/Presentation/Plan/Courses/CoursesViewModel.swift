//
//  CoursesViewModel.swift
//  ITExams
//
//  Created by Андрей Чернышев on 25.04.2022.
//

import RxSwift
import RxCocoa

final class CoursesViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var save = PublishRelay<(Exam, Course)>()
    
    lazy var elements = makeElements()
    lazy var saved = makeSaved()
    lazy var activity = RxActivityIndicator()
    
    private lazy var profileManager = ProfileManager()
    private lazy var coursesManager = CoursesManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension CoursesViewModel {
    func makeElements() -> Driver<[CoursesTableElement]> {
        let currentCourse = profileManager
            .obtainExamEnvironment()
            .map { $0?.course }
            .asObservable()
        
        let zipped = profileManager.obtainExams()
            .asObservable()
            .flatMap { [weak self] exams -> Observable<[(Exam, [Course])]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[(Exam, [Course])]> {
                    let zipped = exams.map { exam -> Single<(Exam, [Course])> in
                        return self.coursesManager
                            .obtainCourses(domain: exam.domain, apiKey: exam.api)
                            .map { courses -> (Exam, [Course]) in
                                (exam, courses)
                            }
                    }
                    
                    return Single.zip(zipped)
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
            }
        
        return Observable
            .zip(currentCourse, zipped) { [weak self] currentCourse, zipped -> [CoursesTableElement] in
                guard let self = self else {
                    return []
                }
                
                let currentID = currentCourse?.id ?? -1
                
                var result = [CoursesTableElement]()
                
                zipped.forEach { exam, courses in
                    let group = self.makeGroup(exam: exam, courses: courses, currentCourseID: currentID)
                    result.append(contentsOf: group)
                }
                
                return result
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeGroup(exam: Exam, courses: [Course], currentCourseID: Int) -> [CoursesTableElement] {
        var result = [CoursesTableElement]()
        
        let currentCourseInThisGroup = courses.contains(where: { $0.id == currentCourseID })
        
        let coursesElement = courses.map { course -> CoursesTableCourseElement in
            let isCurrentCourse = course.id == currentCourseID
            
            return CoursesTableCourseElement(course: course,
                                             isCurrent: isCurrentCourse,
                                             isSelected: isCurrentCourse)
        }
        
        let examElement = CoursesTableExamElement(exam: exam,
                                                  courses: coursesElement,
                                                  isOpened: currentCourseInThisGroup)
        
        result.append(.exam(examElement))
        
        if currentCourseInThisGroup {
            coursesElement.enumerated().forEach { index, courseElement in
                result.append(.offset(16.scale))
                result.append(.course(courseElement))
            }
        }
        
        result.append(.offset(32.scale))
        
        return result
    }
    
    func makeSaved() -> Driver<Void> {
        save
            .flatMapLatest { [weak self] exam, course -> Observable<Void> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Void> {
                    self.profileManager
                        .obtainExams()
                        .flatMap { [weak self] exams -> Single<Void> in
                            guard let self = self else {
                                return .never()
                            }
                            
                            let requests = exams
                                .map { environment -> Single<Void> in
                                    if environment.code == exam.code {
                                        return self.profileManager.set(domain: environment.domain,
                                                                       apiKey: environment.api,
                                                                       exam: exam,
                                                                       course: course)
                                    } else {
                                        return self.profileManager.resetCourse(domain: environment.domain,
                                                                               apiKey: environment.api)
                                    }
                                }
                            
                            return Single
                                .zip(requests)
                                .mapToVoid()
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
            }
            .asDriver(onErrorDriveWith: .never())
    }
}
