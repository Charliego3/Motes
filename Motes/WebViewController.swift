//
//  WebView.swift
//  Motes
//
//  Created by Charlie on 2023/2/6.
//

import Foundation
import WebKit

class WebViewController: NSViewController, WKNavigationDelegate {
    var webview: WKWebView?
    
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        let preference = WKWebpagePreferences()
        preference.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preference
        self.webview = WKWebView(frame: .zero, configuration: configuration)
        self.webview?.navigationDelegate = self
        self.webview!.setValue(false, forKey: "drawsBackground")
        self.webview?.layer?.backgroundColor = NSColor.clear.cgColor
        
        self.view = webview!
        
        NSLayoutConstraint.activate([
            webview!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webview!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            webview!.topAnchor.constraint(equalTo: self.view.topAnchor),
            webview!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        guard let path: String = Bundle.main.path(forResource: "index", ofType: "html") else { return }
        let localHTMLUrl = URL(fileURLWithPath: path, isDirectory: false)
        webview?.loadFileURL(localHTMLUrl, allowingReadAccessTo: localHTMLUrl)
        webview?.allowsBackForwardNavigationGestures = true
    }
}

extension WebViewController {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
    }
}
