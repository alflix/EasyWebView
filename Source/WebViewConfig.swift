//
//  WebViewConfig.swift
//  EasyWebView
//
//  Created by John on 2019/10/18.
//  Copyright © 2019 John. All rights reserved.
//

import UIKit
import WebKit

public typealias BoolBlock = (_ boolen: Bool) -> Void
public typealias ReceiveScriptMessageBlock = (_ userContentController: WKUserContentController, _ message: WKScriptMessage) -> Void

public struct WebViewConfig {
    /// 弹窗确定按钮的文字
    public static var alertConfirmTitle: String = "Done"
    /// 弹窗取消按钮的文字
    public static var alertCancelTitle: String = "Cancel"
    /// 进度条完成部分进度的颜色(默认蓝)
    public static var progressTintColor: UIColor = UIColor.blue
    /// 进度条总进度的颜色
    public static var progressTrackTintColor: UIColor = .white
}
