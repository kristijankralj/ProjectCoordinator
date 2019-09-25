//
//  FakeNavigationController.swift
//  CoordinatorKitTests
//
//  Created by Kristijan Kralj on 15/01/2019.
//  Copyright © 2019 Kristijan Kralj. All rights reserved.
//

import UIKit

class FakeNavigationController: UINavigationController {

    var popCallCount = 0
    var presentCallCount = 0
    var poppedViewController: UIViewController?
    var dismissCallCount = 0
    var popToRootViewControllers: [UIViewController]?
    var presentAnimatedOption: Bool!
    var popAnimatedOption: Bool!

    override func popViewController(animated: Bool) -> UIViewController? {
        popCallCount += 1
        popAnimatedOption = animated
        return poppedViewController
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCallCount += 1
        presentAnimatedOption = flag
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCallCount += 1
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        return popToRootViewControllers
    }
}
