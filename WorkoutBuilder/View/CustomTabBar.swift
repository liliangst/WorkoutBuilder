//
//  CustomTabBar.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 23/08/2023.
//

import UIKit

@IBDesignable class CustomTabBar: UITabBar {
    
    override func draw(_ rect: CGRect) {
        setFontForItems(font: .systemFont(ofSize: 18, weight: .heavy))
    }
    
    private func setFontForItems(font: UIFont) {
        guard let items = items else {
            return
        }
        for item in items {
            item.image = item.image?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(font: font))
        }
    }
}
