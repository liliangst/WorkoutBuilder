//
//  Sets.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 04/09/2023.
//

import Foundation
import RealmSwift

class Sets: WorkoutElement {
    @Persisted var exercices: List<Exercice>
    @Persisted var restBetweenSet: TimeInterval?
    @Persisted var numberOfSets: Int
}
