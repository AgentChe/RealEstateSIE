//
//  GlobalDefinitions.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let realestateDomainUrl = "https://bank3.thinkaboutapps.com"
    static let realestateApiKey = "5LBaYgwx4ciqjyD2"
    
    static let sieDomainUrl = "https://bank.thinkaboutapps.com"
    static let sieApiKey = "64P1aommP0QGfGdL"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "pbKj2igJNswuVjCz"
    
    static let termsOfServiceUrl = URL(string: "https://thinkaboutapps.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://thinkaboutapps.com/policy")!
    static let contactUsUrl = URL(string: "https://thinkaboutapps.com/contact")!
    
    enum Paygate {
        static let lifetime = "prep.exams.realestatesie.lifetime"
        static let subscription = "prep.exams.realestatesie.monthly"
    }
}
