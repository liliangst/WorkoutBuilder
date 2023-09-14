//
//  FavoriteWorkoutsCarousel.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 23/08/2023.
//

import SwiftUI

struct FavoriteWorkoutsCarousel: View {
    var body: some View {
        Group {
            // Empty State
            VStack {
                Text("Pas de séances favorites")
                    .font(FontFamily.PoppinsExtraBold.regular.swiftUIFont(size: 24))
                    .foregroundColor(Asset.gray1.swiftUIColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                Text("Pour ajouter une séance à vos favoris, appuyer sur l'étoile en haut à droite d'une séance.")
                    .font(FontFamily.DMSans.regular.swiftUIFont(size: 20))
                    .foregroundColor(Asset.gray1.swiftUIColor)
                    .multilineTextAlignment(.center)
            }
            .minimumScaleFactor(0.01)
        }
    }
}

struct FavoriteWorkoutsCarousel_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteWorkoutsCarousel()
    }
}
