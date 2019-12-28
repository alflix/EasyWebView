//
//  SecondViewController.swift
//  EasyWebView
//
//  Created by John on 2019/10/25.
//  Copyright © 2019 EasyWebView. All rights reserved.
//

import UIKit

class SecondViewController: WebViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var toolView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubviewToFront(toolView)
        urlString = "http://mdetail.tmall.com/templates/pages/desc?id=604372762402"
    }

    @IBAction func back(_ sender: Any) {
        goBack()
    }

    @IBAction func next(_ sender: Any) {
        goForward()
    }

    @IBAction func reload(_ sender: Any) {
        reload()
    }

    @IBAction func share(_ sender: Any) {
    }
}
