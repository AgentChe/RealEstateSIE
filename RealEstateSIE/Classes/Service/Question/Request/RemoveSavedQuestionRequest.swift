//
//  RemoveSavedQuestionRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 07.06.2022.
//

import Alamofire

struct RemoveSavedQuestionRequest: APIRequestBody {
    let domain: String
    let apiKey: String
    let userToken: String
    let questionId: Int
    
    var url: String {
        domain + "/api/tests/remove"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": apiKey,
            "_user_token": userToken,
            "question_id": questionId,
            "platform": 3
        ]
    }
}
