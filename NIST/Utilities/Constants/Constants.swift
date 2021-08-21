//
//  Constants.swift
//  NIST
//
//  Created by Miguel Fraire on 7/29/21.
//

import UIKit

enum Images {
    static let logo = UIImage(named: "NIST-Logo")
    static let emptyStatelogo = UIImage(named: "NIST-Logo-Empty")
    static let placeholder = UIImage(named: "placeholder")
    static let minimalistLogo = UIImage(named: "launchscreen")
}

enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}
