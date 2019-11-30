//
//  FirstViewController.swift
//  EasyWebView
//
//  Created by John on 2019/10/25.
//  Copyright © 2019 EasyWebView. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {
    private var webCellHeights: [CGFloat] = [300, 300]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(WebViewCell.self, forCellReuseIdentifier: String(describing: WebViewCell.self))
    }
}

extension FirstViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return webCellHeights[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: WebViewCell.self, for: indexPath)
        if indexPath.row == 0 {
            let exampleHtml: String = """
            <div><img src=\"http://qiniu-cdn.dev.ganyouyun.com/uploads/product/shop/2019/9/21/470da7be-c3a6-442f-8853-ff0027a83196.png\" />\n<div><img src=\"http://qiniu-cdn.dev.ganyouyun.com/uploads/product/shop/2019/9/21/799f42cc-00e6-4744-bda8-306a8b1d7684.png\" />\n<div><img src=\"http://qiniu-cdn.dev.ganyouyun.com/uploads/product/shop/2019/9/21/68acb3a4-b63c-45e6-bd76-9a3470795472.png\" />\n<div><img src=\"http://qiniu-cdn.dev.ganyouyun.com/uploads/product/shop/2019/9/21/be2ed308-444c-4260-a6ec-55c3f33bb922.png\" />\n<div><img src=\"http://qiniu-cdn.dev.ganyouyun.com/uploads/product/shop/2019/9/21/416da1b4-1711-4094-8237-12c2263ca462.png\" />\n<div><img src=\"http://qiniu-cdn.dev.ganyouyun.com/uploads/product/shop/2019/9/21/7acacf6f-f6ed-40b0-bab8-3bad2bb5d7ec.png\" />\n<div><img src=\"http://qiniu-cdn.dev.ganyouyun.com/uploads/product/shop/2019/9/21/831e5745-6a3d-4531-9d1b-57ac329cf218.png\" />\n<div><img src=\"http://qiniu-cdn.dev.ganyouyun.com/uploads/product/shop/2019/9/21/d0a2df52-e5c2-48fc-8aa4-e6fcfef1f4b9.png\" />\n<div><img src=\"http://qiniu-cdn.dev.ganyouyun.com/uploads/product/shop/2019/9/21/e88255b4-8cb6-4932-8388-1445b52c011c.png\" />\n<div><img src=\"http://qiniu-cdn.dev.ganyouyun.com/uploads/product/shop/2019/9/21/4a7c2e59-cdec-4445-84d3-92a8b8a6f4b4.png\" />\n<div><img src=\"http://qiniu-cdn.dev.ganyouyun.com/uploads/product/shop/2019/9/21/39502db8-e29b-4bba-82f8-11d7dfcd7859.png\" />\n<div><img src=\"http://qiniu-cdn.dev.ganyouyun.com/uploads/product/shop/2019/9/21/a0932901-0baa-4c4a-a038-7bdec6c79b3a.png\" /></div>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>
            """
            cell.setupHtmlString(exampleHtml, appendingHtmlFormat: true, delegate: self)
        } else {
            cell.setupURLString("https://www.ifanr.com/app/1270042", delegate: self, isAddObservers: true)
        }
        return cell
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableView.fixWebViewCellRenderingWhite()
    }
}

extension FirstViewController: WebViewCellDelegate {
    func heightChangeObserve(in cell: UITableViewCell, contentHeight: CGFloat) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        webCellHeights[indexPath.row] = contentHeight
        print("😄: \(indexPath.row) - \(contentHeight)")
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
