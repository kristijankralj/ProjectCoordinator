//
//  Coordinator.swift
//  CoordinatorKit
//
//  Created by Kristijan Kralj on 04/01/2019.
//  Copyright © 2019 Kristijan Kralj. All rights reserved.
//

import Foundation

public protocol Coordinator: class, Presentable {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    
    public func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    public func removeDependency(_ coordinator: Coordinator?) {
        if let coordinator = coordinator, let index = childCoordinators.firstIndex(where: {$0 === coordinator}){
            childCoordinators.remove(at: index)
        }
    }
}
