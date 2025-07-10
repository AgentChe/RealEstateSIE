//
//  GetPlanTestRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 09.06.2022.
//

import Alamofire

struct GetPlanTestRequest: APIRequestBody {
    let domain: String
    let apiKey: String
    let userToken: String
    let testId: Int
    let activeSubscription: Bool
    
    var url: String {
        domain + "/api/plan/test"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": apiKey,
            "_user_token": userToken,
            "id": testId,
            "user_is_premium": activeSubscription,
            "platform": 3
        ]
    }
}
