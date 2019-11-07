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
    /// loading html text
    /// - Parameter htmlString: html text
    /// - Parameter appendingHtmlFormat: whether append html base format
    /// - Parameter delegate: height of webView observer
    /// - Parameter isAddObservers: whether observer scrollView.contentSize , sometimes don't need to add observer of contentSize, sometimes need, depend the url
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
        let basePath = Bundle.main.bundlePath
        let baseURL = NSURL.fileURL(withPath: basePath)
        DispatchQueue.main.async {
            self.webView.loadHTMLString(self.htmlString!, baseURL: baseURL)
        }
        if isAddObservers {
            addObservers()
        }
    }

    /// loading url string
    /// - Parameter urlString: url string
    /// - Parameter delegate: webView height obsever delegate
    /// - Parameter isAddObservers: whether observer scrollView.contentSize , sometimes don't need to add observer of contentSize, sometimes need, depend the url
    func setupURLString(_ urlString: String?,
                        delegate: WebViewCellDelegate?,
                        isAddObservers: Bool = false) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        self.delegate = delegate
        self.urlString = urlString
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
        }
        if isAddObservers {
            addObservers()
        }
    }
}

public extension UITableView {
    /// fix ios10 webview rendering issue, called in scrollViewDidScroll
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
            guard let self = self else { return }
            let height = self.webView.scrollView.contentSize.height
            self.contentSizeChange(height: height)
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
            guard let self = self, let result = result as? Double else { return }
            self.contentSizeChange(height: CGFloat(result))
        }
    }
}
