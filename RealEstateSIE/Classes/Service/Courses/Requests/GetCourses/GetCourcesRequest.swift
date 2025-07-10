//
//  GetCoursesRequest.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import Alamofire

struct GetCourcesRequest: APIRequestBody {
    let domain: String
    let apiKey: String
    let userToken: String
    
    var url: String {
        domain + "/api/courses/list"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey,
            "_user_token": userToken,
            "platform": 3
        ]
    }
}
