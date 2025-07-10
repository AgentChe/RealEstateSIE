//
//  GetTestRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import Alamofire

struct GetTestRequest: APIRequestBody {
    let domain: String
    let apiKey: String
    let userToken: String
    let courseId: Int
    let testId: Int?
    let time: Int?
    let activeSubscription: Bool
    
    var url: String {
        domain + "/api/testings/get"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": apiKey,
            "_user_token": userToken,
            "course_id": courseId,
            "user_is_premium": activeSubscription,
            "platform": 3
        ]
        
        if let testId = testId {
            params["test_id"] = testId
        }
        
        if let time = time {
            params["exam_minutes"] = time
        }
        
        return params
    }
}
