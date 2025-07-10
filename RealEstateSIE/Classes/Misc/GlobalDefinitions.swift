//
//  GlobalDefinitions.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let realestateDomainUrl = "https://bank3.apps-by-konstantin.com"
    static let realestateApiKey = "5LBaYgwx4ciqjyD2"
    
    static let sieDomainUrl = "https://bank.apps-by-konstantin.com"
    static let sieApiKey = "64P1aommP0QGfGdL"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "pbKj2igJNswuVjCz"
    
    static let applicationTag = "EXAMS_REAL_ESTATE_2"
    static let amplitudeApiKey = "8b5138249711d65974423b54fed13562"
    
    static let termsOfServiceUrl = URL(string: "https://appslaunchpad.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://appslaunchpad.com/policy")!
    static let contactUsUrl = URL(string: "https://appslaunchpad.com/contact")!
    
    enum Paygate {
        static let lifetime = "prep.exams.realestatesie.lifetime"
        static let subscription = "prep.exams.realestate.monthly"
    }
}
