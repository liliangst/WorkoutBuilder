//
//  FavoriteWorkoutsCarousel.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 23/08/2023.
//

import SwiftUI

struct FavoriteWorkoutsCarousel: View {
    @State private var isEmptyState: Bool = false
    @State private var currentIndex = WorkoutManager.favoriteWorkouts.startIndex
    @State var favoriteWorkoutTransition: AnyTransition = .identity
    var body: some View {
        Group {
            if isEmptyState {
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
            } else
            {
                HStack {
                    
                    Spacer()
                    Button {
                        withAnimation(.interpolatingSpring(stiffness: 150, damping: 15)) {
                            if currentIndex > WorkoutManager.favoriteWorkouts.startIndex {
                                currentIndex -= 1
                            } else {
                                currentIndex = WorkoutManager.favoriteWorkouts.endIndex - 1
                            }
                            favoriteWorkoutTransition = .asymmetric(insertion: .move(edge: .leading), removal: .identity)
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Asset.gray1.swiftUIColor)
                            .font(.system(size: 40, weight: .heavy))
                    }
                    Spacer()
                    
                    VStack {
                        ForEach(WorkoutManager.favoriteWorkouts, id: \.self) { index in
                            if index == currentIndex {
                                WorkoutCardSquare(title: "Title", numberOfExercises: currentIndex)
                                    .transition(favoriteWorkoutTransition)
                            }
                        }
                        HStack {
                            ForEach(WorkoutManager.favoriteWorkouts,  id: \.self) { index in
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(width: 10)
                                    .foregroundColor(index == currentIndex ? Asset.green.swiftUIColor : Asset.gray2.swiftUIColor)
                            }
                        }
                    }
                    Spacer()
                    Button {
                        withAnimation(.interpolatingSpring(stiffness: 150, damping: 15)) {
                            if currentIndex < WorkoutManager.favoriteWorkouts.endIndex - 1 {
                                currentIndex += 1
                            } else {
                                currentIndex = WorkoutManager.favoriteWorkouts.startIndex
                            }
                            favoriteWorkoutTransition = .asymmetric(insertion: .move(edge: .trailing), removal: .identity)
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Asset.gray1.swiftUIColor)
                            .font(.system(size: 40, weight: .heavy))
                    }
                    Spacer()
                }
                .padding(.horizontal, 15)
            }
        }
    }
}

#Preview {
    FavoriteWorkoutsCarousel()
}
