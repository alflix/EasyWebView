//
//  String+HTML.swift
//  EasyWebView
//
//  Created by John on 2019/12/28.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension String {
    func appendingHtmlFormat(contentWidth: CGFloat) -> String {
        let html = """
        <html>
        <head>
        <meta name="viewport", content="width=\(contentWidth), initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no\">
        <style>
        body { font-size: 100%; text-align: justify;}
        p { margin:0 !important; }
        span { line-height:normal !important }
        table { width: 100% !important;}
        img { max-width:100%; width: 100%; height:auto; padding:0; border:0; margin:0; vertical-align:bottom;}
        </style>
        </head>
        <body>
        \(self)
        </body>
        </html>
        """
        return html
    }
}
