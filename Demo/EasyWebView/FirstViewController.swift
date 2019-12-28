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
            <p><img src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/bfe83f8d-95d0-4df6-8ddc-c362f2469152.jpg\" /></p>\n<div><img src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/ba02bf38-85eb-4d9d-aba4-0e3837a22f44.png\" />\n<div><img src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/88f8dd2d-0add-4a8a-91b7-dafde04bc4a6.jpg\" />\n<div><img src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/907de475-a355-4e1b-8b41-ef2cc97604e0.png\" />\n<div><img src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/8078e156-8552-4c25-bbca-ea501b55b8e3.png\" />\n<div><img src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/8412bfe5-68f8-4dc1-ba83-d221cae64d9d.png\" />\n<div><img src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/8cb99b48-d0b6-4ced-9e6a-9dc79bab9fba.jpg\" />\n<div><img src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/b710d6f4-673b-4255-b432-31f57b5f861c.png\" />\n<div><img src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/39fc3b94-9fca-47cd-be08-86c21d5adf2e.png\" />\n<div><img src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/4a8fae17-29cb-4e21-8352-65e166396d00.jpg\" />\n<div><img src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/ceda96fc-e9e3-4e8a-9cbb-c5b4f68b5705.png\" />\n<div>\n<div><img src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/7d79541c-2c4a-4e69-9f3f-36ab89b732bc.JPG\" />\n<div><img src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/04684a6d-055d-42d8-b93d-45a4670b422d.png\" />\n<div><img src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/06f5b313-42f2-4321-91db-96b919c262ac.png\" />\n<div><img src=\"https://yinggou.oss-cn-shenzhen.aliyuncs.com/junya/655b149a-7c93-4c91-9028-d0cee15201be.JPG\" /></div>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>
            """
            cell.setupHtmlString(exampleHtml, appendingHtmlFormat: true, delegate: self)
        } else {
            cell.setupURLString("http://mdetail.tmall.com/templates/pages/desc?id=604372762402", delegate: self)
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
