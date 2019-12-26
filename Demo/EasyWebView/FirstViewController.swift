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
            cell.setupURLString("http://mdetail.tmall.com/templates/pages/desc?id=604372762402", delegate: self, isAddObservers: true)
        } else {
            let exampleHtml: String = """
            <div>\n    <img\n         src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/9530c8ed-0919-472e-b31d-65726a333b64.png\"\n    />\n</div>\n<div>\n    <img\n         src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/dad45c17-751a-4ff6-b187-8bb48619e309.png\"\n    />\n</div>\n<div>\n    <img\n         src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/92912411-07c7-47a9-9430-84fd0112b631.png\"\n    />\n</div>\n<div>\n    <img\n         src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/fe06560b-17d5-479c-8a76-52b285282304.png\"\n    />\n</div>\n<div>\n    <img\n         src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/4a061541-9068-4b5d-8476-36c8cf12d8d9.png\"\n    />\n</div>\n<div>\n    <img\n         src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/9fbd1651-0b2f-474d-b378-5ad9550eac3b.png\"\n    />\n</div>\n<div>\n    <img\n         src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/4b381d0f-95b6-4b1d-872d-04da935aa940.png\"\n    />\n</div>\n<div>\n    <img\n         src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/61bd1846-bd46-4cfe-9f58-fd34fdd972af.png\"\n    />\n</div>\n<div>\n    <img\n         src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/5b16c765-b358-4913-b247-03006ca77a84.png\"\n    />\n</div>\n<div>\n    <img\n         src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/73fbe914-6436-4e4a-922d-88d68918dc08.png\"\n    />\n</div>\n<div>\n    <img\n         src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/6cdb0a29-c524-4029-b203-a66197d5b35c.png\"\n    />\n</div>\n<div>\n    <img\n         src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/74e83f9f-7ebf-4397-82ce-7910629d19ac.png\"\n    />\n</div>\n<div>\n    <img\n         src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/3efafce5-cbac-4003-978a-01fcb5c2e21a.png\"\n    />\n</div>\n
            """
            cell.setupHtmlString(exampleHtml, appendingHtmlFormat: true, delegate: self)
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
        tableView.beginUpdates()
        tableView.endUpdates()
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
