//
//  Workout.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 04/09/2023.
//

import Foundation
import RealmSwift

class Workout: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var isFavorite: Bool = false
    @Persisted var title: String
    @Persisted var numberOfExercise: Int
    @Persisted var totalDuration: TimeInterval?
    @Persisted var elements: LinkedList<WorkoutElement>? = LinkedList<WorkoutElement>()
}
