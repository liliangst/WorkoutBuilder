//
//  RaisedButtonStyle.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 11/10/2023.
//

import SwiftUI

struct RaisedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let offset: CGFloat = 5
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Asset.gray3.swiftUIColor)
                .offset(y: offset)

            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Asset.gray3.swiftUIColor)
                .offset(y: configuration.isPressed ? offset : 0)
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Asset.gray2.swiftUIColor)
                .padding(5)
                .offset(y: configuration.isPressed ? offset : 0)

            configuration.label
                .offset(y: configuration.isPressed ? offset : 0)
        }
    }
}

