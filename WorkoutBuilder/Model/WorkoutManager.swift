//
//  WorkoutManager.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 19/10/2023.
//

import Foundation
import RealmSwift

class WorkoutManager {
    
    static let shared = WorkoutManager()
    
    var playingWorkout: Workout? {
        didSet {
            guard playingWorkout != nil else {
                NotificationCenter.default.post(name: .WorkoutToPlaySelected, object: false)
                return
            }
            NotificationCenter.default.post(name: .WorkoutToPlaySelected, object: true)
        }
    }
    
    private init() {
        #if DEBUG
        print("Realm : \(realm.configuration.fileURL!)")
        #endif
    }
    
    var realm = try! Realm()

    func configure(with configuration: Realm.Configuration) {
        realm = try! Realm(configuration: configuration)
    }
    
    var favoriteWorkouts: [Workout] {
        workouts.filter({$0.isFavorite})
    }
    var workouts: [Workout] = [Workout]()
    
    func addToFavorite(workout: Workout) {
        if favoriteWorkouts.count < 5 {
            try! realm.write {
                workout.thaw()?.isFavorite = true
            }
        }
    }
    
    func insert(_ workout: Workout) {
        try! realm.write {
            realm.add(workout)
        }
    }
    
    func remove(_ workout: Workout) {
        workout.elements.forEach { element in
            removeElement(element)
        }
        try! realm.write {
            realm.delete(workout)
        }
    }
    
    /// Save changes on Realm objects
    func saveChanges(_ completion: () -> ()) {
        try! realm.write {
            completion()
        }
    }

    func removeFromFavorite(workout: Workout) {
        try! realm.write {
            workout.thaw()?.isFavorite = false
            NotificationCenter.default.post(name: .DeleteFavoriteWorkout, object: nil)
        }
    }
    
    func saveElement(_ element: WorkoutElementObject) {
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
    
    func removeElement(_ element: WorkoutElement) {
        switch element.type {
        case WorkoutElementType.exercise.rawValue:
            guard let exercise = realm.object(ofType: Exercise.self, forPrimaryKey: element.id) else { break }
            removeElementObject(exercise)
        case WorkoutElementType.rest.rawValue:
            guard let rest = realm.object(ofType: Rest.self, forPrimaryKey: element.id) else { break }
            removeElementObject(rest)
        case WorkoutElementType.set.rawValue:
            guard let `set` = realm.object(ofType: Sets.self, forPrimaryKey: element.id) else { break }
            `set`.elements.forEach { element in
                removeElement(element)
            }
            removeElementObject(`set`)
        default:
            break
        }
        
    }
    
    func removeElementObject(_ element: WorkoutElementObject) {
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
    
    func fetchWorkouts() {
        workouts = realm.objects(Workout.self).map({$0})
    }
    
    func fetchElements(for workout: Workout) {
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
    
    func fetchElements(for set: Sets) {
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
