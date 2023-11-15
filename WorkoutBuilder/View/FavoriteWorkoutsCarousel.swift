//
//  FavoriteWorkoutsCarousel.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 23/08/2023.
//

import SwiftUI
import RealmSwift

struct FavoriteWorkoutsCarousel: View {
    @State private var isEmptyState: Bool = false
    @State private var currentIndex: Int = 0
    @State var favoriteWorkoutTransition: AnyTransition = .identity
    @ObservedResults(Workout.self, where: { $0.isFavorite }) var favoriteWorkouts
    let delegate: EditWorkoutDelegate
    
    var body: some View {
        ZStack {
            if favoriteWorkouts.count == 0 {
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
            } else {
                HStack {
                    
                    Spacer()
                    Button {
                        withAnimation(.interpolatingSpring(stiffness: 150, damping: 15)) {
                            if currentIndex > favoriteWorkouts.startIndex {
                                currentIndex -= 1
                            } else {
                                currentIndex = favoriteWorkouts.endIndex - 1
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
                        ForEach(0..<favoriteWorkouts.count, id: \.self)  { index in
                            if index == currentIndex, favoriteWorkouts.count > index {
                                WorkoutCardSquare(workout: favoriteWorkouts[index], editDelegate: delegate)
                                    .transition(favoriteWorkoutTransition)
                            }
                        }
                        HStack {
                            ForEach(0..<favoriteWorkouts.count, id: \.self) { index in
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
                            if currentIndex < favoriteWorkouts.endIndex - 1 {
                                currentIndex += 1
                            } else {
                                currentIndex = favoriteWorkouts.startIndex
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
                .onReceive(NotificationCenter.default.publisher(for: .DeleteFavoriteWorkout)) { _ in
                    withAnimation(.interpolatingSpring(stiffness: 150, damping: 15)) {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                        favoriteWorkoutTransition = .asymmetric(insertion: .move(edge: .trailing), removal: .identity)
                    }
                }
            }
        }
        .frame(height: 250 )
    }
}
