//
//  GetReviewRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 06.06.2022.
//

import Alamofire

struct GetReviewRequest: APIRequestBody {
    let domain: String
    let apiKey: String
    let userToken: String
    let courseId: Int
    let mode: Int
    let offset: Int
    
    var url: String {
        domain + "/api/review/course"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey,
            "_user_token": userToken,
            "course_id": courseId,
            "mode": mode,
            "offset": offset,
            "platform": 3
        ]
    }
}
