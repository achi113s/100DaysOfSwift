//
//  DetailViewController.swift
//  Project16Maps
//
//  Created by Giorgio Latour on 4/28/23.
//

import UIKit
import WebKit

class WebDetailViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var url: URL!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url))
    }
    
}
