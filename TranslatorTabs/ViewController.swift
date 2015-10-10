//
//  ViewController.swift
//  TranslatorTabs
//
//  Created by 이상현 on 2015. 6. 6..
//  Copyright (c) 2015년 Kurt. All rights reserved.
//

import Cocoa
import WebKit

class CustomWebView : WebView {
    @IBOutlet weak var progressIndicator: NSProgressIndicator!;
}


class ViewController: NSViewController {
    @IBOutlet weak var webView1: CustomWebView!
    @IBOutlet weak var webView2: CustomWebView!
    @IBOutlet weak var webView3: CustomWebView!
    @IBOutlet weak var webView4: CustomWebView!
    @IBOutlet weak var queryTextField: NSTextField!
    
    var query: String! = "" {
        didSet {
            if query != oldValue {
                var originalArray : [AnyObject]? = NSUserDefaults.standardUserDefaults().objectForKey("searchHistory") as? [AnyObject]
                if (originalArray == nil) {
                    originalArray = [AnyObject]()
                }
                
                originalArray?.append(query)
                
                NSUserDefaults.standardUserDefaults().setObject(originalArray, forKey: "searchHistory")
                
                print(originalArray, terminator: "")

                self.loadURLToWebView(
                    buildURL("http://m.endic.naver.com/search.nhn",
                             queryItems: [
                                NSURLQueryItem(name: "searchOption", value: "all"),
                                NSURLQueryItem(name: "query", value: query)
                            ]),
                    webView: webView1);

                self.loadURLToWebView(
                    buildURL("http://m.frdic.naver.com/search.nhn",
                        queryItems: [
                            NSURLQueryItem(name: "query", value: query)
                        ]),
                    webView: webView2);

                self.loadURLToWebView(
                    buildURL(String(format: "http://www.wordreference.com/enfr/%@", query).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding), queryItems: []),
                    webView: webView3
                );

                self.loadURLToWebView(
                    buildURL(String(format: "http://www.wordreference.com/fren/%@", query).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding), queryItems: []),
                    webView: webView4
                );
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
    
    private func buildURL(baseURL: String!, queryItems: [NSURLQueryItem]?) -> NSURL {
        let urlComponents : NSURLComponents = NSURLComponents(string: baseURL)!;
        urlComponents.queryItems = queryItems;
        return urlComponents.URL!;
    }
    
    private func scrollWebViewAfterLoad(webView: WebView!) {
        if (webView == webView1 || webView == webView2) {
            webView?.stringByEvaluatingJavaScriptFromString(String("window.scrollTo(0, 95)"))
        } else if (webView == webView3 || webView == webView4) {
            webView?.stringByEvaluatingJavaScriptFromString(String("window.scrollTo(0, 82)"))
        }
    }
    
    private func startObserveWebView(webView: WebView!) {
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
    
    // WebView Progress Notifications Handlers
    func webViewProgressStarted(notification: NSNotification!) {
        let webView : CustomWebView! = notification.object as! CustomWebView
        webView.progressIndicator.hidden = false;
        webView.progressIndicator.doubleValue = 0.0;
        webView.hidden = true;
    }
    func webViewProgressEstimateChanged(notification: NSNotification!) {
        let webView : CustomWebView! = notification.object as! CustomWebView
        webView.progressIndicator.doubleValue = webView.estimatedProgress
        scrollWebViewAfterLoad(webView!)
        webView.hidden = true;
    }
    func webViewProgressFinished(notification: NSNotification!) {
        let webView : CustomWebView! = notification.object as! CustomWebView
        webView.progressIndicator.hidden = true;
        scrollWebViewAfterLoad(webView!)
        webView.hidden = false;
    }

    private func loadURLToWebView(URL: NSURL!, webView: WebView!) {
        webView.mainFrame.stopLoading();
        webView.mainFrame.loadRequest(NSURLRequest(URL: URL))
    }
    
    @IBAction func onQueryChanged(sender: NSTextField) {
        query = sender.stringValue;
    }
}