//
//  FakeCoordinator.swift
//  CoordinatorKitTests
//
//  Created by Kristijan Kralj on 04/01/2019.
//  Copyright © 2019 Kristijan Kralj. All rights reserved.
//

import UIKit

@testable import ProjectCoordinator

final class FakeCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    func toPresentable() -> UIViewController {
        return UIViewController()
    }
    
    var startCount = 0
    
    func start() {
        startCount += 1
    }
}
