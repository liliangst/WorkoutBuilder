//
//  FontExtension.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 15/08/2023.
//

// MARK: UIKit Extension
import UIKit

extension UIFont {
    static let appTitle1Font: UIFont = UIFont(name: "Poppins-ExtraBold", size: 32)!
    static let appTitle2Font: UIFont = UIFont(name: "Poppins-ExtraBold", size: 24)!
    static let appContentFont: UIFont = UIFont(name: "DMSans-Regular", size: 20)!
}

// MARK: SwiftUI Extension
import SwiftUI

extension Font {
    static let appTitle1Font: Font = .custom("Poppins-ExtraBold", size: 32)
    static let appTitle2Font: Font = .custom("Poppins-ExtraBold", size: 24)
    static let appContentFont: Font = .custom("DMSans-Regular", size: 20)
}
