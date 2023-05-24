//
//  ViewController.swift
//  Project4
//
//  Created by Ning, Xinran on 22/5/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {  // Parent class first, then protocols

  // create web view
  var website: String?
  var webView: WKWebView!

//  override func loadView() {
//    webView = WKWebView()
//    webView.navigationDelegate = self
//    view = webView
//  }

  override func viewDidLoad() {
    super.viewDidLoad()

    webView = WKWebView()
    webView.navigationDelegate = self
    view.addSubview(webView)
    webView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: view.topAnchor),
      webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])


    let url = URL(string: "https://" + (website ?? "google.com"))!  // iOS requires https
    webView.load(URLRequest(url: url))
    webView.allowsBackForwardNavigationGestures = true

    webView.uiDelegate = self
    webView.allowsLinkPreview = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    webView.stopLoading()
    
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
  }

}

