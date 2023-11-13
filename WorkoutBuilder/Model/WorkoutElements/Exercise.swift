//
//  Exercise.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 04/09/2023.
//

import Foundation
import RealmSwift

class Exercise: Object, WorkoutElementObject {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var title: String
    @Persisted var numberOfReps: Int?
    @Persisted var weight: Int?
    @Persisted var duration: TimeInterval?
}
