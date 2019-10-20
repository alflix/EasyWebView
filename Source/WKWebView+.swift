//
//  WKWebView+.swift
//  Demo
//
//  Created by John on 2019/10/19.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import Foundation
import WebKit

class WeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    weak var scriptDelegate: WKScriptMessageHandler?

    deinit {
        print("WeakScriptMessageDelegate is deinit")
    }

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
        static var receiveScriptMessageHandlerWrapper: String = "com.ganguo.receiveScriptMessageHandler"
    }

    var receiveScriptMessageHandler: ReceiveScriptMessageBlock? {
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

    func addScriptMessageHandler(scriptNames: [String], receiveScriptMessageHandler: ReceiveScriptMessageBlock? = nil) {
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
