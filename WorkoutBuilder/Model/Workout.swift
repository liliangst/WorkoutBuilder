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
    @Persisted var elements: List<WorkoutElement> = List<WorkoutElement>()
    var elementsObjects: [WorkoutElementObject] = []
    
    func insert(_ element: WorkoutElementObject) {
        let type = WorkoutElementType(type: element)
        let elementId: ObjectId
        switch element {
        case is Exercise:
            elementId = (element as! Exercise).id
        case is Rest:
            elementId = (element as! Rest).id
        case is Sets:
            elementId = (element as! Sets).id
        default:
            elementId = ObjectId("")
        }
        let workoutElement = WorkoutElement(id: elementId, type: type.rawValue)
        WorkoutManager.saveChanges {
            elements.append(workoutElement)
        }
        elementsObjects.append(element)
        WorkoutManager.saveElement(element)
    }
    
    func remove(_ element: WorkoutElementObject) {
        let elementId: ObjectId?
        let elementIndex: Int?
        
        switch element {
        case is Exercise:
            elementId = (element as! Exercise).id
            elementIndex = elementsObjects.firstIndex(where: { elementObject in
                guard let exercise = (elementObject as? Exercise) else {
                    return false
                }
                return exercise.id == elementId
            })!
        case is Rest:
            elementId = (element as! Rest).id
            elementIndex = elementsObjects.firstIndex(where: { elementObject in
                guard let rest = (elementObject as? Rest) else {
                    return false
                }
                return rest.id == elementId
            })!
        case is Sets:
            elementId = (element as! Sets).id
            elementIndex = elementsObjects.firstIndex(where: { elementObject in
                guard let sets = (elementObject as? Sets) else {
                    return false
                }
                return sets.id == elementId
            })!
        default:
            elementId = nil
            elementIndex = nil
        }
        
        guard let elementIndex = elementIndex else {
            return
        }
        WorkoutManager.saveChanges {
            elements.remove(at: elementIndex)
        }
        elementsObjects.remove(at: elementIndex)
        WorkoutManager.removeElement(element)
    }
}
