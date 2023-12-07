//
//  WorkoutTests.swift
//  WorkoutBuilderTests
//
//  Created by Lilian Grasset on 30/11/2023.
//

import XCTest
import RealmSwift
@testable import WorkoutBuilder

final class WorkoutTests: XCTestCase {

    var workout: Workout!
    
    override class func setUp() {
        let realmConfiguration = Realm.Configuration(inMemoryIdentifier: "WorkoutTests")
        WorkoutManager.shared.configure(with: realmConfiguration)
    }
    
    override func tearDown() {
        WorkoutManager.shared.saveChanges {
            WorkoutManager.shared.realm.deleteAll()
        }
    }
    
    override func setUp() {
        super.setUp()
        workout = Workout()
    }

    func testInsertExercise() {
        let element = Exercise()
        
        workout.insert(element)
        
        XCTAssertEqual(workout.elements[0].id, element.id)
        XCTAssert(workout.elementsObjects[0] === element)
    }
    
    func testInsertRest() {
        let element = Rest()
        
        workout.insert(element)
        
        XCTAssertEqual(workout.elements[0].id, element.id)
        XCTAssert(workout.elementsObjects[0] === element)
    }
    
    func testInsertSets() {
        let element = Sets()
        
        workout.insert(element)
        
        XCTAssertEqual(workout.elements[0].id, element.id)
        XCTAssert(workout.elementsObjects[0] === element)
    }
    
    func testRemoveElement() {
        let element = Exercise()
        workout.insert(element)
        
        workout.remove(element)
        
        XCTAssert(workout.elements.isEmpty)
        XCTAssert(workout.elementsObjects.isEmpty)
    }
    
    func testTryRemoveElementNotSaved() {
        let element = Exercise()
        
        XCTAssertNoThrow(workout.remove(element))
    }
    
}
