//
//  AppDelegate.swift
//  Demo
//
//  Created by John on 2019/3/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.backgroundColor = .white
        return true
    }
}

public extension UIView {
    /// 递归查找子类 UIView
    ///
    /// - Parameter name: UIView 的类名称
    /// - Returns: 找到的 UIView
    func recursiveFindSubview(of name: String) -> UIView? {
        for view in subviews {
            if view.isKind(of: NSClassFromString(name)!) {
                return view
            }
        }
        for view in subviews {
            if let tempView = view.recursiveFindSubview(of: name) {
                return tempView
            }
        }
        return nil
    }
}

public func SYSTEM_VERSION_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedSame
}

public func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedDescending
}

public func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedAscending
}

public func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedAscending
}

public func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedDescending
}
