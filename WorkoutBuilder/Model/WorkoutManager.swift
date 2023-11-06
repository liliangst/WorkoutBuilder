//
//  WorkoutManager.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 19/10/2023.
//

import Foundation

class WorkoutManager {
    
    // Temp
    static var favoriteWorkouts: [Workout] = [Workout]()
    static var workouts: [Workout] = [Workout]()
    
    static func addToFavorite(workout: Workout) {
        if favoriteWorkouts.count < 5 {
            workout.isFavorite = true
            favoriteWorkouts.append(workout)
        }
    }

    static func removeFromFavorite(workout: Workout) {
        if let index = favoriteWorkouts.firstIndex(of: workout) {
            workout.isFavorite = false
            favoriteWorkouts.remove(at: index)
        }
    }
}
