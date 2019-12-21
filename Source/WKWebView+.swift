//
//  WKWebView+.swift
//  EasyWebView
//
//  Created by John on 2019/10/19.
//  Copyright © 2019 EasyWebView. All rights reserved.
//

import Foundation
import WebKit

class WeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    weak var scriptDelegate: WKScriptMessageHandler?

    init(_ scriptDelegate: WKScriptMessageHandler) {
        self.scriptDelegate = scriptDelegate
        super.init()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptDelegate?.userContentController(userContentController, didReceive: message)
    }
}

public extension WKWebView {
    fileprivate struct AssociatedKey {
        static var receiveScriptMessageHandlerWrapper: String = "com.EasyWebView.receiveScriptMessageHandler"
    }

    private var receiveScriptMessageHandler: ReceiveScriptMessageBlock? {
        get {
            guard let block = associatedObject(forKey: &AssociatedKey.receiveScriptMessageHandlerWrapper) as? ReceiveScriptMessageBlock else {
                return nil
            }
            return block
        }
        set {
            associate(copyObject: newValue, forKey: &AssociatedKey.receiveScriptMessageHandlerWrapper)
        }
    }

    /// js 用以下的方法调用 iOS 的函数：
    /// window.webkit.messageHandlers. {scriptName}.postMessage(object)
    /// - Parameter scriptNames: 函数名称数组
    /// - Parameter receiveScriptMessageHandler: 回调
    func addScriptMessageHandler(scriptNames: [String], receiveScriptMessageHandler: ReceiveScriptMessageBlock? = nil) {
        self.receiveScriptMessageHandler = receiveScriptMessageHandler
        for scriptName in scriptNames {
            configuration.userContentController.removeScriptMessageHandler(forName: scriptName)
            configuration.userContentController.add(WeakScriptMessageDelegate(self), name: scriptName)
        }
    }
}

extension WKWebView: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        receiveScriptMessageHandler?(userContentController, message)
    }
}
