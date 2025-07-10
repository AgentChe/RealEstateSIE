//
//  RequestReview.swift
//  ATITEASHESI
//
//  Created by Андрей Чернышев on 09.07.2025.
//

import StoreKit

final class RequestReview {
    static func request() {
        guard let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        else {
            return
        }

        AmplitudeManager.shared
            .logEvent(name: "Rating Request")

        DispatchQueue.main.async {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
