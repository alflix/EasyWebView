<img src="https://tva1.sinaimg.cn/large/006tNbRwgy1g9uyopblfsj310g082jrw.jpg">

[![Version](https://img.shields.io/cocoapods/v/EasyWebView.svg?style=flat)](http://cocoapods.org/pods/EasyWebView)
[![License](https://img.shields.io/cocoapods/l/EasyWebView.svg?style=flat)](http://cocoapods.org/pods/EasyWebView)
[![Platform](https://img.shields.io/cocoapods/p/EasyWebView.svg?style=flat)](http://cocoapods.org/pods/EasyWebView)
![Swift](https://img.shields.io/badge/%20in-swift%205.0-orange.svg)

## Introduction

EasyWebView enables application to use WKWebView easily, in UIViewController or UITableViewCell.

## Features

- one line code to use WKWebView by loading url or html string.
- smart and easy to adjust height of WebView in UITableViewCell.
- easy and safe to use ScriptMessageHandler.
- support common WKWebView feature.

## Installation 

### Requirements 

- Swift 4.2 
- iOS 9.0

### Cocoapods

EasyWebView is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
platform :ios, '9.0'
pod "EasyWebView"
```

> If you want to load http url, Don't forget the Privacy Description in `info.plist`.

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## Usage 

**Use WebViewController**

```swift 
class ViewController: UIViewController {
    func pushToWebViewController() {
        pushToWebByLoadingURL("google.com", title: "Google")
    }
}
```

**Override WebViewController**

```swift 
class CustomWebViewController: WebViewController {
    override var isShowProgressView: Bool { return false }
    override var isShowTitle: Bool { return false }
}
```

**Use WebViewCell**

```swift 
class ViewController: UITableViewController {
    private var webCellHeight: CGFloat = 300

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(WebViewCell.self, forCellReuseIdentifier: String(describing: WebViewCell.self))
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return webCellHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: WebViewCell.self, for: indexPath)
        // test url and scriptNames
        cell.setupURLString("https://test.com", delegate: self, isAddObservers: true)
        cell.webView.addScriptMessageHandler(scriptNames: ["test"]) { (_, message) in
            print("😄: \(message.body)")
        }
        return cell
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableView.fixWebViewCellRenderingWhite()
    }
}
```

## Author

Does your organization or project use EasyWebView? Please let me know by email. John, jieyuanz24@gmail.com .

## License 

EasyWebView is available under the MIT license.
