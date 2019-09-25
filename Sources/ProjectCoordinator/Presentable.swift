//
//  Presentable.swift
//  CoordinatorKit
//
//  Created by Kristijan Kralj on 08/01/2019.
//  Copyright © 2019 Kristijan Kralj. All rights reserved.
//

import UIKit

public protocol Presentable {
    func toPresentable() -> UIViewController
}

extension UIViewController: Presentable {
    public func toPresentable() -> UIViewController {
        return self
    }
}
