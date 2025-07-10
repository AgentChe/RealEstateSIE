//
//  GetOnboardingTestRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 06.06.2022.
//

import Alamofire

struct GetOnboardingTestRequest: APIRequestBody {
    let domain: String
    let apiKey: String
    let userToken: String
    let courseId: Int
    
    var url: String {
        domain + "/api/testings/onboarding_set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": apiKey,
            "_user_token": userToken,
            "course_id": courseId,
            "platform": 3
        ]
    }
}
