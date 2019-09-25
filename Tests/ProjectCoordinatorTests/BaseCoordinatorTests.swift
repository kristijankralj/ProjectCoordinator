//
//  BaseCoordinatorTests.swift
//  CoordinatorKitTests
//
//  Created by Kristijan Kralj on 04/01/2019.
//  Copyright © 2019 Kristijan Kralj. All rights reserved.
//

import XCTest
@testable import ProjectCoordinator

class BaseCoordinatorTests: XCTestCase {
    
    func test_addDependency_adds_coordinator_to_child_coordinators() {
        let coordinatorUnderTest = createCoordinator()
        let stubCoordinator = FakeCoordinator()
        coordinatorUnderTest.addDependency(stubCoordinator)
        
        XCTAssertTrue(coordinatorUnderTest.childCoordinators[0] === stubCoordinator)
    }
    
    func test_addDependency_does_not_append_same_coordinator_twice() {
        let coordinatorUnderTest = createCoordinator()
        let stubCoordinator = FakeCoordinator()
        coordinatorUnderTest.addDependency(stubCoordinator)
        coordinatorUnderTest.addDependency(stubCoordinator)
        
        XCTAssertEqual(1, coordinatorUnderTest.childCoordinators.count)
    }
    
    func test_removeDependency_removes_child_coordinator() {
        let coordinatorUnderTest = createCoordinator()
        let stubCoordinator = FakeCoordinator()
        coordinatorUnderTest.addDependency(stubCoordinator)
        coordinatorUnderTest.removeDependency(stubCoordinator)
        
        XCTAssertEqual(0, coordinatorUnderTest.childCoordinators.count)
    }
    
    func test_removeDependency_does_not_remove_coordinator_which_is_not_present_in_child_cotrnollers() {
        let coordinatorUnderTest = createCoordinator()
        let stubCoordinator = FakeCoordinator()
        coordinatorUnderTest.addDependency(stubCoordinator)
        coordinatorUnderTest.removeDependency(FakeCoordinator())
        
        XCTAssertEqual(1, coordinatorUnderTest.childCoordinators.count)
    }
    
    private func createCoordinator() -> FakeCoordinator {
        return FakeCoordinator()
    }
}
