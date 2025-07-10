//
//  GetCustomTestRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 15.06.2022.
//

import Alamofire

struct GetCustomTestRequest: APIRequestBody {
    let domain: String
    let apiKey: String
    let userToken: String
    let courseId: Int
    let activeSubscription: Bool
    let subjects: [Int]
    let includeMissedQuestions: Bool
    let includeAnsweredQuestions: Bool
    let questionsCount: Int
    
    var url: String {
        domain + "/api/testings/custom"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": apiKey,
            "_user_token": userToken,
            "course_id": courseId,
            "user_is_premium": activeSubscription,
            "subjects": subjects,
            "include_missed_questions": includeMissedQuestions,
            "include_answered_questions": includeAnsweredQuestions,
            "size": questionsCount,
            "platform": 3
        ]
    }
}
