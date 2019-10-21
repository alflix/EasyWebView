//
//  WebViewCell.swift
//  EasyWebView
//
//  Created by John on 10/14/18.
//  Copyright © 2019 John. All rights reserved.
//

import UIKit
import WebKit

public protocol WebViewCellDelegate: NSObjectProtocol {
    func heightChangeObserve(in cell: UITableViewCell, contentHeight: CGFloat)
}

public class WebViewCell: UITableViewCell {
    public lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        webView.navigationDelegate = self
        return webView
    }()

    private var webViewHeight: CGFloat = 0
    private var observation: NSKeyValueObservation?
    private var hasLoad: Bool = false
    private weak var delegate: WebViewCellDelegate?
    private var htmlString: String?
    private var urlString: String?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        webView.frame = bounds
    }
}

public extension WebViewCell {
    /// 加载 html 字符串
    /// - Parameter htmlString: html 字符串
    /// - Parameter appendingHtmlFormat: 是否拼接上 htlm 的基本格式
    /// - Parameter delegate: 代理，监听网页高度
    /// - Parameter isAddObservers: 是否监听 scrollView.contentSize
    func setupHtmlString(_ htmlString: String?,
                         appendingHtmlFormat: Bool = false,
                         delegate: WebViewCellDelegate?,
                         isAddObservers: Bool = false) {
        guard let htmlString = htmlString else { return }
        self.delegate = delegate
        if appendingHtmlFormat {
            // 和计算高度有关
            let html = """
            <html>
            <head>
            <meta name="viewport", content="width=\(bounds.width), initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no\">
            <style>
            body { font-size: 100%; text-align: justify;}
            table { width: 100% !important;}
            img { max-width:100%; width: 100%; height:auto; padding:0; border:0; margin:0; vertical-align:bottom;}
            </style>
            </head>
            <body>
            \(htmlString)
            </body>
            </html>
            """
            self.htmlString = html
        } else {
            self.htmlString = htmlString
        }
        if hasLoad { return }
        let basePath = Bundle.main.bundlePath
        let baseURL = NSURL.fileURL(withPath: basePath)
        DispatchQueue.main.async {
            self.webView.loadHTMLString(self.htmlString!, baseURL: baseURL)
        }
        if isAddObservers {
            addObservers()
        }
        hasLoad = true
    }

    /// 加载 url
    /// - Parameter urlString: url 字符串
    /// - Parameter delegate: 代理，监听网页高度
    /// - Parameter isAddObservers: 是否监听 scrollView.contentSize （默认通过 document.body.scrollHeight 获取可能不对，例如 url 是异步调 API 再渲染的）
    func setupURLString(_ urlString: String?,
                        delegate: WebViewCellDelegate?,
                        isAddObservers: Bool = false) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        self.delegate = delegate
        self.urlString = urlString
        if hasLoad { return }
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
        }
        if isAddObservers {
            addObservers()
        }
        hasLoad = true
    }
}

public extension UITableView {
    /// 处理 ios10 webview 白屏 scrollViewDidScroll 中调用
    /// https://stackoverflow.com/questions/39549103/wkwebview-not-rendering-correctly-in-ios-10
    func fixWebViewCellRenderingWhite() {
        if #available(iOS 11.0, *) { return }
        for cell in visibleCells where cell is WebViewCell {
            if let webView = cell.contentView.recursiveFindSubview(of: "WKWebView") {
                webView.setNeedsLayout()
            }
        }
    }
}

private extension WebViewCell {
    func setupUI() {
        contentView.addSubview(webView)
    }

    func addObservers() {
        // 如果 html 正确的话，例如有添加了<meta>，document.body.scrollHeight 获取的高度是正确的，
        // 不需要 addObservers，而且发现 iOS12 以上，使用这个方法高度反而会异常（在添加了<meta>之后）
        observation = webView.observe(\WKWebView.scrollView.contentSize) { [weak self] (_, _) in
            guard let strongSelf = self else { return }
            let height = strongSelf.webView.scrollView.contentSize.height
            strongSelf.contentSizeChange(height: height)
        }
    }

    func contentSizeChange(height: CGFloat) {
        if webViewHeight == height { return }
        delegate?.heightChangeObserve(in: self, contentHeight: height)
        webViewHeight = height
        webView.setNeedsLayout()
    }
}

extension WebViewCell: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] (result, _) in
            guard let strongSelf = self, let result = result as? Double else { return }
            strongSelf.contentSizeChange(height: CGFloat(result))
        }
    }
}
