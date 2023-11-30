//
//  WorkoutCardSquare.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 17/10/2023.
//

import SwiftUI

struct WorkoutCardSquare: View {
    @State var isFavorite: Bool
    
    let delegate: EditWorkoutDelegate
    var workout: Workout
    
    init(workout: Workout, editDelegate: EditWorkoutDelegate) {
        delegate = editDelegate
        
        self.workout = workout
        _isFavorite = State(initialValue: workout.isFavorite)
    }
    
    var body: some View {
        Button {
            
        } label: {
            ZStack {
                VStack(spacing: 5) {
                    HStack {
                        Text(workout.title)
                            .font(FontFamily.PoppinsExtraBold.regular.swiftUIFont(fixedSize: 24))
                            .foregroundColor(Asset.Colors.gray1.swiftUIColor)
                        
                        Spacer()
                        
                        Button {
                            if workout.isFavorite {
                                WorkoutManager.shared.removeFromFavorite(workout: workout)
                            } else {
                                WorkoutManager.shared.addToFavorite(workout: workout)
                            }
                            isFavorite = workout.isFavorite
                        } label: {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                                .resizable()
                                .scaledToFit()
                                .font(.system(size: 24, weight: .heavy))
                                .frame(width: 20, height: 20)
                                .foregroundColor(Asset.Colors.green.swiftUIColor)
                        }.padding(.bottom, 15)
                        
                    }
                    .padding([.horizontal, .top], 15)
                    
                    Spacer()
                    
                    Text("") // Empty description for card
                    .font(FontFamily.DMSans.regular.swiftUIFont(fixedSize: 20))
                    .foregroundColor(Asset.Colors.gray1.swiftUIColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    
                    Spacer()
                    
                    HStack(spacing: 5) {
                        Spacer()
                        
                        Button {
                            WorkoutManager.shared.playingWorkout = workout
                        } label: {
                            Image(systemName: "play.fill")
                                .resizable()
                                .scaledToFit()
                                .font(.system(size: 24, weight: .heavy))
                                .frame(width: 20, height: 20)
                                .foregroundColor(Asset.Colors.gray1.swiftUIColor)
                                .padding(10)
                        }
                        
                        Button {
                            delegate.edit(workout)
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                                .font(.system(size: 24, weight: .heavy))
                                .frame(width: 20, height: 20)
                                .foregroundColor(Asset.Colors.gray1.swiftUIColor)
                                .padding(10)
                        }
                    }
                    .padding([.horizontal, .bottom], 10)
                }
            }
        }
        .frame(width: 220, height: 215)
        .padding(.vertical, 10)
        .buttonStyle(RaisedButtonStyle())
    }
}
