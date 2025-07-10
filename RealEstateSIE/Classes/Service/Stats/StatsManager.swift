//
//  StatsManager.swift
//  ITExams
//
//  Created by Андрей Чернышев on 18.05.2022.
//

import RxSwift

protocol StatsManagerProtocol {
    func resetStats(domain: String, apiKey: String, courseId: Int) -> Single<Void>
    func obtainStats(domain: String, apiKey: String, courseId: Int) -> Single<Stats?>
    func obtainTestStats(domain: String, apiKey: String, courseId: Int, userTestId: Int) -> Single<TestStats?>
}

final class StatsManager: StatsManagerProtocol {
    private lazy var xorRequestWrapper = XORRequestWrapper()
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: Public
extension StatsManager {
    func resetStats(domain: String, apiKey: String, courseId: Int) -> Single<Void> {
        let request = ResetStatsRequest(domain: domain,
                                        apiKey: apiKey,
                                        userToken: sessionManager.internalId,
                                        courseId: courseId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: {
                StatsMediator.shared.notifyAboutResetedStats()
            })
    }
    
    func obtainStats(domain: String, apiKey: String, courseId: Int) -> Single<Stats?> {
        let request = GetStatsRequest(domain: domain,
                                      apiKey: apiKey,
                                      userToken: sessionManager.internalId,
                                      courseId: courseId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { try GetStatsResponseMapper.map(from: $0) }
    }
    
    func obtainTestStats(domain: String, apiKey: String, courseId: Int, userTestId: Int) -> Single<TestStats?> {
        let request = GetTestStatsRequest(domain: domain,
                                          apiKey: apiKey,
                                          userToken: sessionManager.internalId,
                                          courseId: courseId,
                                          userTestId: userTestId,
                                          peek: true)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: apiKey)
            .map { GetTestStatsResponseMapper.map(from: $0, key: apiKey) }
    }
}
