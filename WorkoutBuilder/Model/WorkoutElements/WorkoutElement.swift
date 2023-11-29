//
//  WorkoutElement.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 04/09/2023.
//

import Foundation
import RealmSwift

protocol WorkoutElementObject: AnyObject {}

class WorkoutElement: EmbeddedObject {
    @Persisted var id: ObjectId
    @Persisted var type: WorkoutElementType.RawValue
    
    convenience init(id: ObjectId, type: WorkoutElementType.RawValue) {
        self.init()
        self.id = id
        self.type = type
    }
}

enum WorkoutElementType: Int {
    case exercise = 0
    case rest = 1
    case set = 2
    
    init(type: WorkoutElementObject) {
        switch type {
        case is Exercise:
            self.init(rawValue: 0)!
        case is Rest:
            self.init(rawValue: 1)!
        case is Sets:
            self.init(rawValue: 2)!
        default:
            self.init(rawValue: 0)!
        }
    }
}


