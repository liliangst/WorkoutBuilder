//
//  Rest.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 04/09/2023.
//

import Foundation
import RealmSwift

class Rest: Object, WorkoutElementObject {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var duration: TimeInterval? = 30
}
