//
//  SearchContentView.swift
//  TranslatorTabs
//
//  Created by 이상현 on 2015. 6. 7..
//  Copyright (c) 2015년 Kurt. All rights reserved.
//

import Cocoa
import WebKit

class SearchContentView: NSView {
    
    private var webView : WebView! = nil
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        __init()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        __init()
    }
    
    private func __init() {
        var webView : WebView! = WebView()
        
        webView.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable

        func startObserveWebView(webView: WebView!) {
            NSNotificationCenter.defaultCenter().addObserver(
                self,
                selector: "webViewProgressStarted:",
                name: WebViewProgressStartedNotification,
                object: webView
            )
            NSNotificationCenter.defaultCenter().addObserver(
                self,
                selector: "webViewProgressEstimateChanged:",
                name: WebViewProgressEstimateChangedNotification,
                object: webView
            )
            NSNotificationCenter.defaultCenter().addObserver(
                self,
                selector: "webViewProgressFinished:",
                name: WebViewProgressFinishedNotification,
                object: webView
            )
        }
        startObserveWebView(webView)
        
        addSubview(webView)
        self.webView = webView
    }
    
    private func webViewProgressStarted(notification: NSNotification!) {
        var webView : WebView? = notification.object as? WebView
    }
    private func webViewProgressEstimateChanged(notification: NSNotification!) {
        var webView : WebView? = notification.object as? WebView
        print(webView?.estimatedProgress)
        webView?.stringByEvaluatingJavaScriptFromString(String("window.scrollTo(0, 90)"))
    }
    private func webViewProgressFinished(notification: NSNotification!) {
        var webView : WebView? = notification.object as? WebView
        webView?.stringByEvaluatingJavaScriptFromString(String("window.scrollTo(0, 90)"))
    }
    
}
