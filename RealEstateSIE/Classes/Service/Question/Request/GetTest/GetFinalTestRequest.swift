//
//  GetFinalTestRequest.swift
//  ATITEASHESI
//
//  Created by Андрей Чернышев on 19.08.2025.
//

import Alamofire

struct GetFinalTestRequest: APIRequestBody {
    let domain: String
    let apiKey: String
    let userToken: String
    let courseId: Int
    let activeSubscription: Bool
    
    var url: String {
        domain + "/api/plan/final_exam"
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
            "platform": 3
        ]
    }
}
