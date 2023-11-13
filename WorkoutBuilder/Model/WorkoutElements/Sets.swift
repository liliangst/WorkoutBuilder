//
//  Sets.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 04/09/2023.
//

import Foundation
import RealmSwift

class Sets: Object, WorkoutElementObject {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var restBetweenSet: TimeInterval? = 60
    @Persisted var numberOfSets: Int = 1
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
                return (elementObject as! Exercise).id == elementId
            })!
        case is Rest:
            elementId = (element as! Rest).id
            elementIndex = elementsObjects.firstIndex(where: { elementObject in
                return (elementObject as! Rest).id == elementId
            })!
        case is Sets:
            elementId = (element as! Sets).id
            elementIndex = elementsObjects.firstIndex(where: { elementObject in
                return (elementObject as! Exercise).id == elementId
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
