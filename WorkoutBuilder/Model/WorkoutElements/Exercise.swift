//
//  Exercise.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 04/09/2023.
//

import Foundation
import RealmSwift

class Exercise: WorkoutElement {
    @Persisted var title: String
    @Persisted var numberOfReps: Int?
    @Persisted var weight: Int?
    @Persisted var duration: TimeInterval?
}
