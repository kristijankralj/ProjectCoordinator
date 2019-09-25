//
//  Router.swift
//  CoordinatorKit
//
//  Created by Kristijan Kralj on 08/01/2019.
//  Copyright © 2019 Kristijan Kralj. All rights reserved.
//

import UIKit

public protocol Routing: class, Presentable {
    
    var rootViewController: UIViewController? { get }
    
    func present(_ module: Presentable)
    func present(_ module: Presentable, animated: Bool)
    
    func push(_ module: Presentable)
    func push(_ module: Presentable, animated: Bool)
    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?)
    
    func popModule()
    func popModule(animated: Bool)
    
    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    
    func setRootModule(_ module: Presentable)
    func setRootModule(_ module: Presentable, hideBar: Bool)
    
    func popToRootModule(animated: Bool)
}

public final class Router: NSObject, Routing {

    public var rootViewController: UIViewController? {
        return navigationController.viewControllers.first
    }

    private let navigationController: UINavigationController
    private var completions: [UIViewController : () -> Void]

    public init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        self.completions = [:]
        super.init()
        self.navigationController.delegate = self
    }
    
    
    public func present(_ module: Presentable) {
        present(module, animated: true)
    }
    
    public func present(_ module: Presentable, animated: Bool) {
        navigationController.present(module.toPresentable(), animated: animated, completion: nil)
    }
    
    public func push(_ module: Presentable) {
        push(module, animated: true, completion: nil)
    }
    
    public func push(_ module: Presentable, animated: Bool) {
        push(module, animated: animated, completion: nil)
    }
    
    public func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?) {
        let controller = module.toPresentable()
        
        guard controller is UINavigationController == false else {
            return
        }
        
        if let completion = completion {
            completions[controller] = completion
        }
        
        navigationController.pushViewController(controller, animated: animated)
    }
    
    public func popModule() {
        popModule(animated: true)
    }
    
    public func popModule(animated: Bool) {
        if let controller = navigationController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    public func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
    
    public func dismissModule(animated: Bool, completion: (() -> Void)?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    public func setRootModule(_ module: Presentable) {
        setRootModule(module, hideBar: false)
    }
    
    public func setRootModule(_ module: Presentable, hideBar: Bool) {
        // Call all completions so all coordinators can be deallocated
        completions.forEach { $0.value() }
        navigationController.setViewControllers([module.toPresentable()], animated: false)
        navigationController.isNavigationBarHidden = hideBar
    }
    
    public func popToRootModule(animated: Bool) {
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            controllers.forEach { runCompletion(for: $0) }
        }
    }
    
    public func toPresentable() -> UIViewController {
        return navigationController
    }
    
    fileprivate func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}

extension Router: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        // Ensure the view controller is popping
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(poppedViewController) else {
                return
        }
        
        runCompletion(for: poppedViewController)
    }
}
