//
//  Workout.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 04/09/2023.
//

import Foundation
import RealmSwift

class Workout: Object, ObjectKeyIdentifiable {
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
        if !elements.contains(where: {$0.id == workoutElement.id}) {
            WorkoutManager.shared.saveChanges {
                if isFrozen {
                    thaw()?.elements.append(workoutElement)
                } else {
                    elements.append(workoutElement)
                }
            }
        }
        elementsObjects.append(element)
        WorkoutManager.shared.saveElement(element)
    }
    
    func remove(_ element: WorkoutElementObject) {
        guard let elementIndex = elementsObjects.firstIndex(where: {$0 === element}) else {
            return
        }
        WorkoutManager.shared.saveChanges {
            if isFrozen {
                thaw()?.elements.remove(at: elementIndex)
            } else {
                elements.remove(at: elementIndex)
            }
        }
        elementsObjects.remove(at: elementIndex)
        WorkoutManager.shared.removeElementObject(element)
    }
}
