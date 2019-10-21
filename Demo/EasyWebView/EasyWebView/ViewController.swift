//
//  ViewController.swift
//  EasyWebView
//
//  Created by John on 2019/10/21.
//  Copyright © 2019 John. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    private var webCellHeight: CGFloat = 300

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(WebViewCell.self, forCellReuseIdentifier: String(describing: WebViewCell.self))
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return webCellHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: WebViewCell.self, for: indexPath)
        cell.setupURLString("http://192.168.199.127:8081/?id=2", delegate: self, isAddObservers: true)
        cell.webView.addScriptMessageHandler(scriptNames: ["openProductDetail"]) { (_, message) in
            print("😄: \(message.body)")
        }
        return cell
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableView.fixWebViewCellRenderingWhite()
    }
}

extension ViewController: WebViewCellDelegate {
    func heightChangeObserve(in cell: UITableViewCell, contentHeight: CGFloat) {
        webCellHeight = contentHeight
        tableView.reloadData()
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }
}

