//
//  WorkoutManagerTests.swift
//  WorkoutBuilderTests
//
//  Created by Lilian Grasset on 04/12/2023.
//

import XCTest
import RealmSwift
@testable import WorkoutBuilder

final class WorkoutManagerTests: XCTestCase {
    
    override class func setUp() {
        let realmConfiguration = Realm.Configuration(inMemoryIdentifier: "WorkoutManagerTests")
        WorkoutManager.shared.configure(with: realmConfiguration)
    }
    
    override func tearDown() {
        WorkoutManager.shared.saveChanges {
            WorkoutManager.shared.realm.deleteAll()
            WorkoutManager.shared.workouts = []
        }
    }

    func testInsertWorkout() {
        let workout = Workout()
        
        WorkoutManager.shared.insert(workout)
        
        let savedWorkouts = WorkoutManager.shared.realm.objects(Workout.self)
        XCTAssertEqual(savedWorkouts[0], workout)
    }
    
    func testRemoveWorkout() {
        let workout = Workout()
        let exercise = Exercise()
        workout.insert(exercise)
        WorkoutManager.shared.insert(workout)
        
        WorkoutManager.shared.remove(workout)
        
        let savedWorkouts = WorkoutManager.shared.realm.objects(Workout.self)
        XCTAssert(savedWorkouts.isEmpty)
    }
    
    func testFetchWorkouts() {
        let workout = Workout()
        WorkoutManager.shared.insert(workout)
        
        WorkoutManager.shared.fetchWorkouts()
        
        XCTAssertEqual(WorkoutManager.shared.workouts, [workout])
    }
    
    func testAddToFavorite() {
        let workout = Workout()
        WorkoutManager.shared.insert(workout)
        
        WorkoutManager.shared.addToFavorite(workout: workout)
        
        WorkoutManager.shared.fetchWorkouts()
        XCTAssert(WorkoutManager.shared.workouts[0].isFavorite)
    }
    
    func testGetFavoriteWorkouts() {
        let workout = Workout()
        WorkoutManager.shared.insert(workout)
        
        WorkoutManager.shared.addToFavorite(workout: workout)
        
        WorkoutManager.shared.fetchWorkouts()
        XCTAssertEqual(WorkoutManager.shared.favoriteWorkouts, [workout])
    }
    
    func testRemoveFromFavoriteWorkouts() {
        let workout = Workout()
        WorkoutManager.shared.insert(workout)
        WorkoutManager.shared.addToFavorite(workout: workout)
        
        WorkoutManager.shared.removeFromFavorite(workout: workout)
        
        WorkoutManager.shared.fetchWorkouts()
        XCTAssert(WorkoutManager.shared.favoriteWorkouts.isEmpty)
    }
    
    func testSaveElementExercise() {
        let exercise = Exercise()
        
        WorkoutManager.shared.saveElement(exercise)
        
        let savedExercises = WorkoutManager.shared.realm.objects(Exercise.self)
        XCTAssertEqual(savedExercises[0], exercise)
    }
    
    func testSaveElementRest() {
        let rest = Rest()
        
        WorkoutManager.shared.saveElement(rest)
        
        let savedRests = WorkoutManager.shared.realm.objects(Rest.self)
        XCTAssertEqual(savedRests[0], rest)
    }
    
    func testSaveElementSets() {
        let set = Sets()
        
        WorkoutManager.shared.saveElement(set)
        
        let savedSets = WorkoutManager.shared.realm.objects(Sets.self)
        XCTAssertEqual(savedSets[0], set)
    }
    
    func testRemoveElementObjectExercise() {
        let exercise =  Exercise()
        WorkoutManager.shared.saveElement(exercise)
        
        WorkoutManager.shared.removeElementObject(exercise)
        
        let savedExercises = WorkoutManager.shared.realm.objects(Exercise.self)
        XCTAssert(savedExercises.isEmpty)
    }
    
    func testRemoveElementObjectRest() {
        let rest =  Rest()
        WorkoutManager.shared.saveElement(rest)
        
        WorkoutManager.shared.removeElementObject(rest)
        
        let savedRests = WorkoutManager.shared.realm.objects(Rest.self)
        XCTAssert(savedRests.isEmpty)
    }
    
    func testRemoveElementObjectSets() {
        let set =  Sets()
        WorkoutManager.shared.saveElement(set)
        
        WorkoutManager.shared.removeElementObject(set)
        
        let savedSets = WorkoutManager.shared.realm.objects(Sets.self)
        XCTAssert(savedSets.isEmpty)
    }
    
    func testRemoveElementExercise() {
        let exercise =  Exercise()
        let element = WorkoutElement(id: exercise.id, type: WorkoutElementType.exercise.rawValue)
        WorkoutManager.shared.saveElement(exercise)
        
        WorkoutManager.shared.removeElement(element)
        
        let savedExercises = WorkoutManager.shared.realm.objects(Exercise.self)
        XCTAssert(savedExercises.isEmpty)
    }
    
    func testRemoveElementRest() {
        let rest =  Rest()
        let element = WorkoutElement(id: rest.id, type: WorkoutElementType.rest.rawValue)
        WorkoutManager.shared.saveElement(rest)
        
        WorkoutManager.shared.removeElement(element)
        
        let savedRests = WorkoutManager.shared.realm.objects(Rest.self)
        XCTAssert(savedRests.isEmpty)
    }
    
    func testRemoveElementSets() {
        let set =  Sets()
        let exercise = Exercise()
        let rest = Rest()
        set.insert(exercise)
        set.insert(rest)
        let element = WorkoutElement(id: set.id, type: WorkoutElementType.set.rawValue)
        WorkoutManager.shared.saveElement(set)
        
        WorkoutManager.shared.removeElement(element)
        
        let savedSets = WorkoutManager.shared.realm.objects(Sets.self)
        XCTAssert(savedSets.isEmpty)
        let savedExercises = WorkoutManager.shared.realm.objects(Exercise.self)
        XCTAssert(savedExercises.isEmpty)
        let savedRests = WorkoutManager.shared.realm.objects(Rest.self)
        XCTAssert(savedRests.isEmpty)
    }
    
    func testFetchElementForWorkout() {
        let exercise = Exercise()
        let rest = Rest()
        let set = Sets()
        let workout = Workout()
        workout.insert(exercise)
        workout.insert(rest)
        workout.insert(set)
        
        WorkoutManager.shared.fetchElements(for: workout)
        
        XCTAssertFalse(workout.elementsObjects.isEmpty)
        XCTAssertEqual(workout.elementsObjects[0] as! Exercise, exercise)
        XCTAssertEqual(workout.elementsObjects[1] as! Rest, rest)
        XCTAssertEqual(workout.elementsObjects[2] as! Sets, set)
    }
    
    func testFetchElementForSet() {
        let exercise = Exercise()
        let rest = Rest()
        let set = Sets()
        let workout = Workout()
        set.insert(exercise)
        set.insert(rest)
        workout.insert(set)
        
        WorkoutManager.shared.fetchElements(for: set)
        
        XCTAssertFalse(set.elementsObjects.isEmpty)
        XCTAssertEqual(set.elementsObjects[0] as! Exercise, exercise)
        XCTAssertEqual(set .elementsObjects[1] as! Rest, rest)
    }
}
