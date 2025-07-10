//
//  ResetCourseRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 04.07.2022.
//

import Alamofire
import Foundation

struct ResetCourseRequest: APIRequestBody {
    let domain: String
    let apiKey: String
    let userToken: String

    var url: String {
        domain + "/api/users/set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey,
            "_user_token": userToken,
            "current_application_course_id": 0,
            "platform": 3
        ]
    }
}
