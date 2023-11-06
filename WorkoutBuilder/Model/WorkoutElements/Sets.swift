//
//  Sets.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 04/09/2023.
//

import Foundation
import RealmSwift

class Sets: WorkoutElement {
    @Persisted var elements: LinkedList<WorkoutElement>? = LinkedList<WorkoutElement>()
    @Persisted var restBetweenSet: TimeInterval?
    @Persisted var numberOfSets: Int
}
