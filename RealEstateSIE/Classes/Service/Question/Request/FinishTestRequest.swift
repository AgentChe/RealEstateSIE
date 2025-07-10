//
//  FinishTestRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import Alamofire

struct FinishTestRequest: APIRequestBody {
    let domain: String
    let apiKey: String
    let userToken: String
    let userTestId: Int
    
    var url: String {
        domain + "/api/tests/finish"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": apiKey,
            "_user_token": userToken,
            "user_test_id": userTestId,
            "platform": 3
        ]
    }
}
