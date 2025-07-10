//
//  ResetStatsRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 18.05.2022.
//

import Alamofire

struct ResetStatsRequest: APIRequestBody {
    let domain: String
    let apiKey: String
    let userToken: String
    let courseId: Int

    var url: String {
        domain + "/api/stats/reset"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey,
            "user_token": userToken,
            "course_id": courseId,
            "platform": 3
        ]
    }
}
