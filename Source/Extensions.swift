//
//  Extensions.swift
//  EasyWebView
//
//  Created by John on 2019/10/21.
//  Copyright © 2019 John. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
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

extension NSObject {
    /// Sets an associated value for a given object using a weak reference to the associated object.
    /// **Note**: the `key` underlying type must be String.
    func associate(assignObject object: Any?, forKey key: UnsafeRawPointer) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValue(forKey: strKey)
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_ASSIGN)
        didChangeValue(forKey: strKey)
    }

    /// Sets an associated value for a given object using a strong reference to the associated object.
    /// **Note**: the `key` underlying type must be String.
    func associate(retainObject object: Any?, forKey key: UnsafeRawPointer) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValue(forKey: strKey)
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        didChangeValue(forKey: strKey)
    }

    /// Sets an associated value for a given object using a copied reference to the associated object.
    /// **Note**: the `key` underlying type must be String.
    func associate(copyObject object: Any?, forKey key: UnsafeRawPointer) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValue(forKey: strKey)
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        didChangeValue(forKey: strKey)
    }

    /// Returns the value associated with a given object for a given key.
    /// **Note**: the `key` underlying type must be String.
    func associatedObject(forKey key: UnsafeRawPointer) -> Any? {
        return objc_getAssociatedObject(self, key)
    }

    func convertUnsafePointerToSwiftType<T>(_ value: UnsafeRawPointer) -> T {
        return value.assumingMemoryBound(to: T.self).pointee
    }
}

public extension UIScrollView {
    var autualContentInset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return adjustedContentInset
        } else {
            return contentInset
        }
    }
}
