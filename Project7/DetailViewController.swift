//
//  DetailViewController.swift
//  Project7
//
//  Created by Appinventiv on 16/12/19.
//  Copyright © 2019 a. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webview: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webview = WKWebView()
        view = webview
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let petition = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body {font-size: 150%; } </style>
        </head>
        <body>
        \(petition.body)
        </body>
        </head>
"""
        
        webview.loadHTMLString(html, baseURL: nil)
    }
    


}
