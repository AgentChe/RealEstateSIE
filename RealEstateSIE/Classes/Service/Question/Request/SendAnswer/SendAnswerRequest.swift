//
//  SendAnswerRequest.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import Alamofire

struct SendAnswerRequest: APIRequestBody {
    let domain: String
    let apiKey: String
    let userToken: String
    let questionId: Int
    let answerIds: [Int]
    let userTestId: Int

    var url: String {
        domain + "/api/tests/answer"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": apiKey,
            "_user_token": userToken,
            "question_id": questionId,
            "user_test_id": userTestId,
            "answer_ids": answerIds,
            "platform": 3
        ]
    }
}
