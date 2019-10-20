//
//  ViewController.swift
//  Demo
//
//  Created by John on 2019/3/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit
import Reusable

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
//        if let filepath = Bundle.main.path(forResource: "example", ofType: "html") {
//            do {
//                let contents = try String(contentsOfFile: filepath)
//                cell.setupHtmlString(contents, appendingHtmlFormat: true, delegate: self)
//            } catch {
//
//            }
//        }
//        cell.setupURLString("https://junya.dev.ganguomob.com/admin/deal/?app=true", delegate: self, isAddObservers: true)
//        cell.setupURLString("https://jpeshop.dev.ganguomob.com/embedded/product_detail/247", delegate: self)
        cell.setupURLString("https://junya.dev.ganguomob.com/admin/deal/?app=true", delegate: self, isAddObservers: true)
//        cell.webView.addScriptMessageHandler(scriptNames: ["agreeRule"]) { (_, _) in
//            print("😄")
//        }
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
