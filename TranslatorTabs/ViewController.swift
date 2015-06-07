//
//  ViewController.swift
//  TranslatorTabs
//
//  Created by 이상현 on 2015. 6. 6..
//  Copyright (c) 2015년 Kurt. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController {
    @IBOutlet weak var webView1: WebView!
    @IBOutlet weak var webView2: WebView!
    @IBOutlet weak var webView3: WebView!
    @IBOutlet weak var webView4: WebView!
    @IBOutlet weak var queryTextField: NSTextField!
    
    var query: String! = "" {
        didSet {
            if query != oldValue {
                self.loadURLToWebView(String(format: "http://m.endic.naver.com/search.nhn?searchOption=all&query=%@", query), webView: webView1)
                self.loadURLToWebView(String(format: "http://m.frdic.naver.com/search.nhn?query=%@", query), webView: webView2)
                self.loadURLToWebView(String(format: "http://www.wordreference.com/enfr/%@", query), webView: webView3)
                self.loadURLToWebView(String(format: "http://www.wordreference.com/fren/%@", query), webView: webView4)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        startObserveWebView(webView1)
        startObserveWebView(webView2)
        startObserveWebView(webView3)
        startObserveWebView(webView4)
    }
    
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
    
    func webViewProgressStarted(notification: NSNotification!) {
        var webView : WebView? = notification.object as? WebView
//        print(webView)
    }
    func webViewProgressEstimateChanged(notification: NSNotification!) {
        var webView : WebView? = notification.object as? WebView
        print(webView?.estimatedProgress)
    }
    func webViewProgressFinished(notification: NSNotification!) {
        var webView : WebView? = notification.object as? WebView
//        print(webView)
    }
    

    func loadURLToWebView(URLString: String!, webView: WebView!) {
        webView.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: URLString)!))
    }
    
    @IBAction func onQueryChanged(sender: NSTextField) {
        query = sender.stringValue;
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

