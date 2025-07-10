//
//  UIApplication+Extension.swift
//  ATITEASHESI
//
//  Created by Андрей Чернышев on 09.07.2025.
//

import UIKit

extension UIApplication {
    var window: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        return scene.windows.first
    }
}
