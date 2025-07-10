//
//  Exam.swift
//  ITExams
//
//  Created by Андрей Чернышев on 29.03.2022.
//

struct Exam: Codable, Hashable {
    let code: String
    let title: String
    let subTitle: String
    let api: String
    let domain: String
}
