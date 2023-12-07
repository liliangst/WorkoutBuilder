//
//  SetsTests.swift
//  WorkoutBuilderTests
//
//  Created by Lilian Grasset on 06/12/2023.
//

import XCTest
import RealmSwift
@testable import WorkoutBuilder

final class SetsTests: XCTestCase {

    var `set`: Sets!
    
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
        `set` = Sets()
    }

    func testInsertExercise() {
        let element = Exercise()
        
        `set`.insert(element)
        
        XCTAssertEqual(`set`.elements[0].id, element.id)
        XCTAssert(`set`.elementsObjects[0] === element)
    }
    
    func testInsertRest() {
        let element = Rest()
        
        `set`.insert(element)
        
        XCTAssertEqual(`set`.elements[0].id, element.id)
        XCTAssert(`set`.elementsObjects[0] === element)
    }
    
    func testInsertSets() {
        let element = Sets()
        
        `set`.insert(element)
        
        XCTAssert(`set`.elements.isEmpty)
        XCTAssert(`set`.elementsObjects.isEmpty)
    }
    
    func testRemoveElement() {
        let element = Exercise()
        `set`.insert(element)
        
        `set`.remove(element)
        
        XCTAssert(`set`.elements.isEmpty)
        XCTAssert(`set`.elementsObjects.isEmpty)
    }
    
    func testTryRemoveElementNotSaved() {
        let element = Exercise()
        
        XCTAssertNoThrow(`set`.remove(element))
    }
    
    func testSaveElements() {
        let exercise = Exercise()
        let rest = Rest()
        `set`.editedElementsObjectsList = [exercise, rest]
        
        `set`.saveElements()
        
        XCTAssertEqual(`set`.elements[0].id, exercise.id)
        XCTAssert(`set`.elementsObjects[0] === exercise)
        XCTAssertEqual(`set`.elements[1].id, rest.id)
        XCTAssert(`set`.elementsObjects[1] === rest)
    }
}
