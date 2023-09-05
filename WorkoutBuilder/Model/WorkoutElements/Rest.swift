//
//  Rest.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 04/09/2023.
//

import Foundation
import RealmSwift

class Rest: WorkoutElement {
    @Persisted var duration: TimeInterval?
}
