//
//  RouterTests.swift
//  CoordinatorKitTests
//
//  Created by Kristijan Kralj on 08/01/2019.
//  Copyright © 2019 Kristijan Kralj. All rights reserved.
//

import XCTest
@testable import ProjectCoordinator

class RouterTests: XCTestCase {

    func test_rootViewController_returns_first_view_controller_in_navigation_stack() {
        let stubNavigationController = UINavigationController()
        stubNavigationController.setViewControllers([UIViewController()], animated: false)
        let router = createRouter(withNavigation: stubNavigationController)
        
        XCTAssertNotNil(router.rootViewController)
    }

    func test_present_presents_view_controller() {
        let mockNavigationController = FakeNavigationController()
        let router = createRouter(withNavigation: mockNavigationController)
        
        router.present(UIViewController(), animated: true)
        
        XCTAssertEqual(1, mockNavigationController.presentCallCount)
    }
    
    func test_present_presents_view_controller_with_default_animated_option_set_to_true() {
        let mockNavigationController = FakeNavigationController()
        let router = createRouter(withNavigation: mockNavigationController)
        
        router.present(UIViewController())
        
        XCTAssertTrue(mockNavigationController.presentAnimatedOption)
    }
    
    func test_push_pushes_view_controller() {
        let mockNavigationController = UINavigationController()
        let router = createRouter(withNavigation: mockNavigationController)
        
        router.push(UIViewController())
        
        XCTAssertEqual(1, mockNavigationController.viewControllers.count)
    }
    
    func test_push_pushes_view_controller_with_animated_option() {
        let mockNavigationController = UINavigationController()
        let router = createRouter(withNavigation: mockNavigationController)
        
        router.push(UIViewController(), animated: true)
        
        XCTAssertEqual(1, mockNavigationController.viewControllers.count)
    }
    
    func test_push_does_not_push_navigation_controller_to_stack() {
        let mockNavigationController = UINavigationController()
        let router = createRouter(withNavigation: mockNavigationController)
        
        router.push(UINavigationController())
        
        XCTAssertEqual(0, mockNavigationController.viewControllers.count)
    }
    
    func test_popModule_removes_module_from_navigation_stack() {
        let mockNavigationController = FakeNavigationController()
        mockNavigationController.pushViewController(UIViewController(), animated: true)
        let router = createRouter(withNavigation: mockNavigationController)
        
        router.popModule(animated: true)
        
        XCTAssertEqual(1, mockNavigationController.popCallCount)
    }
    
    func test_popModule_removes_module_from_navigation_stack_with_default_animated_option_set_to_true() {
        let mockNavigationController = FakeNavigationController()
        mockNavigationController.pushViewController(UIViewController(), animated: true)
        let router = createRouter(withNavigation: mockNavigationController)

        router.popModule()

        XCTAssertTrue(mockNavigationController.popAnimatedOption)
    }
    
    func test_popModule_runs_completion_for_popped_controller() {
        var completionCalled = false
        let mockNavigationController = FakeNavigationController()
        let stubViewController = UIViewController()
        mockNavigationController.poppedViewController = stubViewController
        
        let router = createRouter(withNavigation: mockNavigationController)

        router.push(stubViewController, animated: true, completion: {
            completionCalled = true
        })
        
        router.popModule(animated: true)
        
        XCTAssertTrue(completionCalled)
    }
    
    func test_dismissModule_removes_module_from_navigation_stack() {
        let mockNavigationController = FakeNavigationController()
        let router = createRouter(withNavigation: mockNavigationController)
        
        router.dismissModule()
        
        XCTAssertEqual(1, mockNavigationController.dismissCallCount)
    }
    
    func test_setRootModule_adds_view_controller_to_the_root_in_navigation_stack() {
        let mockNavigationController = UINavigationController()
        let router = createRouter(withNavigation: mockNavigationController)
        
        router.setRootModule(UIViewController())
        
        XCTAssertEqual(1, mockNavigationController.viewControllers.count)
    }
    
    func test_setRootModule_runs_completions_for_pushed_controllers() {
        var completionCalledForFirstController = false
        var completionCalledForSecondController = false
        let mockNavigationController = FakeNavigationController()
        let firstViewController = UIViewController()
        let secondViewController = UIViewController()
        
        let router = createRouter(withNavigation: mockNavigationController)
        
        router.push(firstViewController, animated: true, completion: {
            completionCalledForFirstController = true
        })
        router.push(secondViewController, animated: true, completion: {
            completionCalledForSecondController = true
        })
        
        router.setRootModule(UIViewController())
        
        XCTAssertTrue(completionCalledForFirstController)
        XCTAssertTrue(completionCalledForSecondController)
    }
    
    func test_setRootModule_shows_navigation_bar_by_default() {
        let mockNavigationController = UINavigationController()
        let router = createRouter(withNavigation: mockNavigationController)
        
        router.setRootModule(UIViewController())
        
        XCTAssertFalse(mockNavigationController.isNavigationBarHidden)
    }
    
    func test_setRootModule_hides_navigation_bar() {
        let mockNavigationController = UINavigationController()
        let router = createRouter(withNavigation: mockNavigationController)
        
        router.setRootModule(UIViewController(), hideBar: true)
        
        XCTAssertTrue(mockNavigationController.isNavigationBarHidden)
    }
    
    func test_setRootModule_shows_navigation_bar() {
        let mockNavigationController = UINavigationController()
        let router = createRouter(withNavigation: mockNavigationController)
        
        router.setRootModule(UIViewController(), hideBar: false)
        
        XCTAssertFalse(mockNavigationController.isNavigationBarHidden)
    }
    
    func test_popToRootModule_pops_to_root_view_controller() {
        var completionCalled = false
        let mockNavigationController = FakeNavigationController()
        let stubViewController = UIViewController()
        mockNavigationController.popToRootViewControllers = [stubViewController]
        
        let router = createRouter(withNavigation: mockNavigationController)
        
        router.push(stubViewController, animated: true, completion: {
            completionCalled = true
        })
        
        router.popToRootModule(animated: true)
        
        XCTAssertTrue(completionCalled)
    }
    
    func test_toPresentable_returns_navigation_controller() {
        let mockNavigationController = UINavigationController()

        let router = createRouter(withNavigation: mockNavigationController)
        
        let viewToPresent = router.toPresentable()
        
        XCTAssertEqual(mockNavigationController, viewToPresent)
    }
    
//    func test_router_as_navigation_controller_delegete_runs_completion_for_popped_view_controller() {
//        let router = createRouter(withNavigation: UINavigationController())
//        
//        router.navigationController(UINavigationController(), didShow: UIViewController(), animated: true)
//        
//        fatalError()
//    }
//    
    func createRouter(withNavigation navigation: UINavigationController) -> Router {
        return Router(navigationController: navigation)
    }
}
