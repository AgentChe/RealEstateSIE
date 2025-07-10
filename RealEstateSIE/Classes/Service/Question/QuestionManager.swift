//
//  QuestionManager.swift
//  ITExams
//
//  Created by Андрей Чернышев on 06.06.2022.
//

import RxSwift

protocol QuestionManagerProtocol {
    func obtainTestsKit(domain: String, apiKey: String, courseId: Int) -> Single<TestsKit?>
    func obtainTest(domain: String, apiKey: String, courseId: Int, testId: Int?, time: Int?, activeSubscription: Bool) -> Single<Test?>
    func obtainTenTest(domain: String, apiKey: String, courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainFailedTest(domain: String, apiKey: String, courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainQotdTest(domain: String, apiKey: String, courseId: Int, activeSubscription: Bool, forceUpdate: Bool) -> Single<QotdTest?>
    func obtainRandomTest(domain: String, apiKey: String, courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainSavedTest(domain: String, apiKey: String, courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainQuickTest(domain: String, apiKey: String, courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainCustomTest(domain: String,
                          apiKey: String,
                          courseId: Int,
                          activeSubscription: Bool,
                          subjectsIds: [Int],
                          includeMissedQuestions: Bool,
                          includeAnsweredQuestions: Bool,
                          questionsCount: Int) -> Single<Test?>
    func obtainPlanTest(domain: String, apiKey: String, testId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainOnboardingTest(domain: String, apiKey: String, courseId: Int, forceUpdate: Bool) -> Single<Test?>
    func obtainReview(domain: String, apiKey: String, courseId: Int, mode: Int, offset: Int) -> Single<[Review]>
    func saveQuestion(domain: String, apiKey: String, questionId: Int) -> Single<Void>
    func removeSavedQuestion(domain: String, apiKey: String, questionId: Int) -> Single<Void>
    func obtainAgainTest(domain: String, apiKey: String, userTestId: Int) -> Single<Test?>
    func finishTest(domain: String, apiKey: String, userTestId: Int) -> Single<Void>
    func sendAnswer(domain: String, apiKey: String, questionId: Int, userTestId: Int, answerIds: [Int]) -> Single<Bool?>
}

final class QuestionManager: QuestionManagerProtocol {
    enum Constants {
        static func qotdTestKey(courseId: Int) -> String {
            String(format: "%@_%i", "question_manager_qotd_test_key", courseId)
        }
        static let onboardingSetKey = "question_manager_onboarding_test_key"
    }
    
    private lazy var xorRequestWrapper = XORRequestWrapper()
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: Public
extension QuestionManager {
    func obtainTestsKit(domain: String, apiKey: String, courseId: Int) -> Single<TestsKit?> {
        let request = GetTestsKitRequest(domain: domain,
                                         apiKey: apiKey,
                                         userToken: sessionManager.internalId,
                                         courseId: courseId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetTestsKitResponse.map(from: $0) }
    }
    
    func obtainTest(domain: String, apiKey: String, courseId: Int, testId: Int?, time: Int?, activeSubscription: Bool) -> Single<Test?> {
        let request = GetTestRequest(domain: domain,
                                     apiKey: apiKey,
                                     userToken: sessionManager.internalId,
                                     courseId: courseId,
                                     testId: testId,
                                     time: time,
                                     activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: apiKey) }
    }
    
    func obtainTenTest(domain: String, apiKey: String, courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        let request = GetTenTestRequest(domain: domain,
                                        apiKey: apiKey,
                                        userToken: sessionManager.internalId,
                                        courseId: courseId,
                                        activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: apiKey) }
    }
    
    func obtainFailedTest(domain: String, apiKey: String, courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        let request = GetFailedTestRequest(domain: domain,
                                           apiKey: apiKey,
                                           userToken: sessionManager.internalId,
                                           courseId: courseId,
                                           activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: apiKey) }
    }
    
    func obtainQotdTest(domain: String,
                        apiKey: String,
                        courseId: Int,
                        activeSubscription: Bool,
                        forceUpdate: Bool) -> Single<QotdTest?> {
        if forceUpdate {
            return loadQotdTest(domain: domain, apiKey: apiKey, courseId: courseId, activeSubscription: activeSubscription)
        }
        
        return cachedQotdTest(courseId: courseId)
            .flatMap { [weak self] test -> Single<QotdTest?> in
                guard let self = self else {
                    return .never()
                }
                
                if let test = test, Calendar.current.isDateInToday(test.creation) {
                    return .just(test)
                }
                
                return self.loadQotdTest(domain: domain, apiKey: apiKey, courseId: courseId, activeSubscription: activeSubscription)
            }
    }
    
    func obtainRandomTest(domain: String, apiKey: String, courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        let request = GetRandomTestRequest(domain: domain,
                                           apiKey: apiKey,
                                           userToken: sessionManager.internalId,
                                           courseId: courseId,
                                           activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: apiKey) }
    }
    
    func obtainSavedTest(domain: String, apiKey: String, courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        let request = GetSavedTestRequest(domain: domain,
                                          apiKey: apiKey,
                                          userToken: sessionManager.internalId,
                                          courseId: courseId,
                                          activeSubscription: activeSubscription)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetTestResponseMapper.map(from: $0) }
    }
    
    func obtainQuickTest(domain: String, apiKey: String, courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        let request = GetCustomTestRequest(domain: domain,
                                           apiKey: apiKey,
                                           userToken: sessionManager.internalId,
                                           courseId: courseId,
                                           activeSubscription: activeSubscription,
                                           subjects: [],
                                           includeMissedQuestions: true,
                                           includeAnsweredQuestions: true,
                                           questionsCount: 10)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: apiKey) }
    }
    
    func obtainCustomTest(domain: String,
                          apiKey: String,
                          courseId: Int,
                          activeSubscription: Bool,
                          subjectsIds: [Int],
                          includeMissedQuestions: Bool,
                          includeAnsweredQuestions: Bool,
                          questionsCount: Int) -> Single<Test?> {
        let request = GetCustomTestRequest(domain: domain,
                                           apiKey: apiKey,
                                           userToken: sessionManager.internalId,
                                           courseId: courseId,
                                           activeSubscription: activeSubscription,
                                           subjects: subjectsIds,
                                           includeMissedQuestions: includeMissedQuestions,
                                           includeAnsweredQuestions: includeAnsweredQuestions,
                                           questionsCount: questionsCount)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: apiKey) }
    }
    
    func obtainPlanTest(domain: String, apiKey: String, testId: Int, activeSubscription: Bool) -> Single<Test?> {
        let request = GetPlanTestRequest(domain: domain,
                                         apiKey: apiKey,
                                         userToken: sessionManager.internalId,
                                         testId: testId,
                                         activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: apiKey) }
    }
    
    func obtainOnboardingTest(domain: String, apiKey: String, courseId: Int, forceUpdate: Bool) -> Single<Test?> {
        forceUpdate ? loadOnboardingTest(domain: domain, apiKey: apiKey, courseId: courseId) : cachedOnboardingTest()
    }
    
    func obtainReview(domain: String, apiKey: String, courseId: Int, mode: Int, offset: Int) -> Single<[Review]> {
        let request = GetReviewRequest(domain: domain,
                                       apiKey: apiKey,
                                       userToken: sessionManager.internalId,
                                       courseId: courseId,
                                       mode: mode,
                                       offset: offset)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: apiKey)
            .map { GetReviewResponse.map(from: $0, key: apiKey) }
    }
    
    func saveQuestion(domain: String, apiKey: String, questionId: Int) -> Single<Void> {
        let request = SaveQuestionRequest(domain: domain,
                                          apiKey: apiKey,
                                          userToken: sessionManager.internalId,
                                          questionId: questionId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func removeSavedQuestion(domain: String, apiKey: String, questionId: Int) -> Single<Void> {
        let request = RemoveSavedQuestionRequest(domain: domain,
                                                 apiKey: apiKey,
                                                 userToken: sessionManager.internalId,
                                                 questionId: questionId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func obtainAgainTest(domain: String, apiKey: String, userTestId: Int) -> Single<Test?> {
        let request = AgainTestRequest(domain: domain,
                                       apiKey: apiKey,
                                       userToken: sessionManager.internalId,
                                       userTestId: userTestId)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: apiKey) }
    }
    
    func finishTest(domain: String, apiKey: String, userTestId: Int) -> Single<Void> {
        let request = FinishTestRequest(domain: domain,
                                        apiKey: apiKey,
                                        userToken: sessionManager.internalId,
                                        userTestId: userTestId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func sendAnswer(domain: String, apiKey: String, questionId: Int, userTestId: Int, answerIds: [Int]) -> Single<Bool?> {
        let request = SendAnswerRequest(domain: domain,
                                        apiKey: apiKey,
                                        userToken: sessionManager.internalId,
                                        questionId: questionId,
                                        answerIds: answerIds,
                                        userTestId: userTestId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { SendAnswerResponseMapper.map(from: $0) }
            .do(onSuccess: { isEndOfTest in
                if isEndOfTest == true {
                    QuestionMediator.shared.notidyAboutTestPassed()
                }
            })
    }
}

// MARK: Private
private extension QuestionManager {
    func loadOnboardingTest(domain: String, apiKey: String, courseId: Int) -> Single<Test?> {
        let request = GetOnboardingTestRequest(domain: domain,
                                               apiKey: apiKey,
                                               userToken: sessionManager.internalId,
                                               courseId: courseId)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: apiKey) }
            .do(onSuccess: { test in
                guard let test = test, let data = try? JSONEncoder().encode(test) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.onboardingSetKey)
            })
    }
    
    func cachedOnboardingTest() -> Single<Test?> {
        Single<Test?>
            .create { event in
                guard
                    let data = UserDefaults.standard.data(forKey: Constants.onboardingSetKey),
                    let test = try? JSONDecoder().decode(Test.self, from: data)
                else {
                    event(.success(nil))
                    return Disposables.create()
                }
                
                event(.success(test))
                
                return Disposables.create()
            }
    }
    
    func loadQotdTest(domain: String, apiKey: String, courseId: Int, activeSubscription: Bool) -> Single<QotdTest?> {
        let request = GetQotdTestRequest(domain: domain,
                                         apiKey: apiKey,
                                         userToken: sessionManager.internalId,
                                         courseId: courseId,
                                         activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: apiKey) }
            .map { test -> QotdTest? in
                guard let test = test else {
                    return nil
                }
                
                return QotdTest(creation: Date(), test: test)
            }
            .do(onSuccess: { test in
                guard let test = test, let data = try? JSONEncoder().encode(test) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.qotdTestKey(courseId: courseId))
            })
    }
    
    func cachedQotdTest(courseId: Int) -> Single<QotdTest?> {
        Single<QotdTest?>
            .create { event in
                guard
                    let data = UserDefaults.standard.data(forKey: Constants.qotdTestKey(courseId: courseId)),
                    let test = try? JSONDecoder().decode(QotdTest.self, from: data)
                else {
                    event(.success(nil))
                    return Disposables.create()
                }
                
                event(.success(test))
                
                return Disposables.create()
            }
    }
}
