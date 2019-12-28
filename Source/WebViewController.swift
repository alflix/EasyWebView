//
//  WebViewController.swift
//  EasyWebView
//
//  Created by John on 2018/12/28.
//  Copyright © 2019 EasyWebView. All rights reserved.
//

import UIKit
import WebKit

open class WebViewController: UIViewController {
    /// loading the html string by append html predefine content
    /// - Parameter htmlString: html string
    /// - Parameter appendingHtmlFormat: whether append html base format
    /// - Parameter delegate: height of webView observer
    public func setupHtmlString(_ htmlString: String, appendingHtmlFormat: Bool = false) {
        if appendingHtmlFormat {
            self.htmlString = htmlString.appendingHtmlFormat(contentWidth: view.bounds.width)
        } else {
            self.htmlString = htmlString
        }
    }

    /// access url string
    public var urlString: String? {
        didSet {
            guard let urlString = urlString, let url = URL(string: urlString) else {
                fatalError("URL can't be nil")
            }
            var request = URLRequest(url: url)
            request.addValue("skey=skeyValue", forHTTPHeaderField: "Cookie")
            webView.load(request)
        }
    }

    /// access html string
    public var htmlString: String? {
        didSet {
            guard let htmlString = htmlString else {
                fatalError("htmlString can't be nil")
            }
            webView.loadHTMLString(htmlString, baseURL: nil)
        }
    }

    /// access urlRequest
    public var urlRequest: URLRequest? {
        didSet {
            guard let urlRequest = urlRequest else {
                fatalError("urlRequest can't be nil")
            }
            webView.load(urlRequest)
        }
    }

    /// whether show progressView of loading
    open var isShowProgressView: Bool {
        return true
    }

    /// whether show title of webView content
    open var isShowTitle: Bool {
        return true
    }

    /// progressView's tintColor
    public var progressTintColor: UIColor = WebViewConfig.progressTintColor
    /// progressView's track tintColor
    public var progressTrackTintColor: UIColor = WebViewConfig.progressTrackTintColor
    /// alert confirm title of runJavaScriptAlertPanelWithMessage, default is  "OK"，can setup at WebViewConfig.alertConfirmTitle
    public var alertConfirmTitle: String = WebViewConfig.alertConfirmTitle
    /// alert confirm title of runJavaScriptAlertPanelWithMessage, default is  "Cancel"，can setup at WebViewConfig.alertCancelTitle
    public var alertCancelTitle: String = WebViewConfig.alertCancelTitle

    public lazy private(set) var webView: WKWebView = {
        let userContentController = WKUserContentController()
        let cookieScript = WKUserScript(source: "document.cookie = 'skey=skeyValue';",
                                        injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(cookieScript)

        let configuration = WKWebViewConfiguration()
        configuration.preferences.minimumFontSize = 1
        configuration.preferences.javaScriptEnabled = true
        configuration.allowsInlineMediaPlayback = true
        configuration.userContentController = userContentController

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true

        webView.uiDelegate = self
        webView.navigationDelegate = self

        return webView
    }()

    public lazy private(set) var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = progressTrackTintColor
        progressView.tintColor = progressTintColor
        return progressView
    }()

    private var loadingObservation: NSKeyValueObservation?
    private var titleObservation: NSKeyValueObservation?
    private var progressObservation: NSKeyValueObservation?

    deinit {
        loadingObservation = nil
        titleObservation = nil
        progressObservation = nil
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        setupUI()
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isShowProgressView {
            let progressViewHeight: CGFloat = 2
            progressView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: progressViewHeight)
            webView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        } else {
            webView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        }
    }
}

// MARK: - UI
private extension WebViewController {
    func setupUI() {
        view.addSubview(webView)
        if isShowProgressView {
            view.addSubview(progressView)
        }
    }

    func showProgressView() {
        let originY = webView.scrollView.autualContentInset.top
        progressView.frame.origin.y = originY
        progressView.isHidden = false
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
    }

    func hideProgressView() {
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
    }
}

// MARK: - Action
public extension WebViewController {
    /// back to last page
    ///
    /// - Parameter completion: whether can back to prefix page
    func goBack(completion: BoolBlock? = nil) {
        if webView.canGoBack {
            webView.goBack()
            completion?(webView.canGoBack)
        }
        completion?(false)
    }

    /// go to next oage
    ///
    /// - Parameter completion: whether can go to next page
    func goForward(completion: BoolBlock? = nil) {
        if webView.canGoForward {
            webView.goForward()
            completion?(webView.canGoForward)
        }
        completion?(false)
    }

    /// reload the webView
    func reload() {
        webView.reload()
    }
}

// MARK: - Function
private extension WebViewController {
    func addObservers() {
        loadingObservation = webView.observe(\WKWebView.isLoading) { [weak self] (_, _) in
            guard let self = self else { return }
            if !self.webView.isLoading {
                self.hideProgressView()
            }
        }
        titleObservation = webView.observe(\WKWebView.title) { [weak self] (webView, _) in
            guard let self = self, self.isShowTitle else { return }
            self.title = self.webView.title
        }
        progressObservation = webView.observe(\WKWebView.estimatedProgress) { [weak self] (_, _) in
            guard let self = self else { return }
            self.showProgressView()
        }
    }
}

// MARK: - WKUIDelegate
extension WebViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView,
                        runJavaScriptAlertPanelWithMessage message: String,
                        initiatedByFrame frame: WKFrameInfo,
                        completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertConfirmTitle, style: .default, handler: { (_) in
            completionHandler()
        }))
        present(alert, animated: false, completion: nil)
    }

    public func webView(_ webView: WKWebView,
                        runJavaScriptConfirmPanelWithMessage message: String,
                        initiatedByFrame frame: WKFrameInfo,
                        completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertConfirmTitle, style: .default, handler: { (_) in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: alertCancelTitle, style: .cancel, handler: { (_) in
            completionHandler(false)
        }))
        present(alert, animated: false, completion: nil)
    }

    public func webView(_ webView: WKWebView,
                        runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?,
                        initiatedByFrame frame: WKFrameInfo,
                        completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        alert.addTextField { (textFiled) in
            textFiled.textColor = .red
        }
        alert.addAction(UIAlertAction(title: alertConfirmTitle, style: .default, handler: { (_) in
            completionHandler(alert.textFields![0].text!)
        }))
        present(alert, animated: false, completion: nil)
    }
}

extension WebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

public extension UIViewController {
    // convenient method: push to WebViewController, and loading url
    func pushToWebByLoadingURL(_ url: String, title: String? = nil) {
        let webViewController = WebViewController()
        webViewController.title = title
        webViewController.urlString = url
        navigationController?.pushViewController(webViewController, animated: true)
    }

    // convenient method: push to WebViewController, and loading html string
    func pushToWebByHTMLString(_ html: String, title: String? = nil) {
        let webViewController = WebViewController()
        webViewController.title = title
        webViewController.setupHtmlString(html, appendingHtmlFormat: true)
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
