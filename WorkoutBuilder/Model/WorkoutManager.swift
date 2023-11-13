//
//  WorkoutManager.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 19/10/2023.
//

import Foundation
import RealmSwift

class WorkoutManager {
    
    static private let realm = try! Realm()

    static var favoriteWorkouts: [Workout] =  [Workout]()
    static var workouts: [Workout] = [Workout]()
    
    static func addToFavorite(workout: Workout) {
        if favoriteWorkouts.count < 5 {
            try! realm.write {
                workout.isFavorite = true
            }
        }
    }
    
    static func insert(_ workout: Workout) {
        try! realm.write {
            realm.add(workout)
        }
    }
    
    static func remove(_ workout: Workout) {
        try! realm.write {
            realm.delete(workout)
        }
    }
    
    /// Save changes on Realm objects
    static func saveChanges(_ completion: () -> ()) {
        try! realm.write {
            completion()
        }
    }

    static func removeFromFavorite(workout: Workout) {
        try! realm.write {
            workout.isFavorite = false
        }
    }
    
    static func add(element: WorkoutElement, to workout: Workout) {
        try! realm.write {
            workout.elements.append(element)
        }
    }
    
    static func add(element: WorkoutElement, to set: Sets) {
        try! realm.write {
            set.elements.append(element)
        }
    }
    
    static func saveElement(_ element: WorkoutElementObject) {
        try! realm.write {
            switch element {
            case is Exercise:
                realm.add(element as! Exercise)
            case is Rest:
                realm.add(element as! Rest)
            case is Sets:
                realm.add(element as! Sets)
            default:
                break
            }
        }
    }
    
    static func removeElement(_ element: WorkoutElementObject) {
        try! realm.write {
            switch element {
            case is Exercise:
                realm.delete(element as! Exercise)
            case is Rest:
                realm.delete(element as! Rest)
            case is Sets:
                realm.delete(element as! Sets)
            default:
                break
            }
        }
    }
    
    static func fetchWorkouts() {
        workouts = realm.objects(Workout.self).map({$0})
        favoriteWorkouts = workouts.filter({$0.isFavorite})
    }
    
    static func fetchElements(for workout: Workout) {
        workout.elementsObjects = []
        workout.elements.forEach { element in
            switch element.type {
            case WorkoutElementType.exercise.rawValue:
                guard let elementObject = realm.object(ofType: Exercise.self, forPrimaryKey: element.id) else { break }
                workout.elementsObjects.append(elementObject)
            case WorkoutElementType.rest.rawValue:
                guard let elementObject = realm.object(ofType: Rest.self, forPrimaryKey: element.id) else { break }
                workout.elementsObjects.append(elementObject)
            case WorkoutElementType.set.rawValue:
                guard let elementObject = realm.object(ofType: Sets.self, forPrimaryKey: element.id) else { break }
                workout.elementsObjects.append(elementObject)
            default:
                break
            }
        }
    }
    
    static func fetchElements(for set: Sets) {
        set.elementsObjects = []
        set.elements.forEach { element in
            switch element.type {
            case WorkoutElementType.exercise.rawValue:
                guard let elementObject = realm.object(ofType: Exercise.self, forPrimaryKey: element.id) else { break }
                set.elementsObjects.append(elementObject)
            case WorkoutElementType.rest.rawValue:
                guard let elementObject = realm.object(ofType: Rest.self, forPrimaryKey: element.id) else { break }
                set.elementsObjects.append(elementObject)
            default:
                break
            }
        }
    }
}
