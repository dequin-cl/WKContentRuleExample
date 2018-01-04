//
//  ViewController.swift
//  Filtering WkView
//
//  Created by Iván Antonio Galaz Jeria on 02-01-18.
//  Copyright © 2018 dequin. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    let request = URLRequest(url: URL(string: "https://stackoverflow.com/questions/32119975/how-to-block-external-resources-to-load-on-a-wkwebview")!)

    var hasContentBlockers = false

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.webView.addObserver(self,
                                 forKeyPath: "estimatedProgress",
                                 options: .new,
                                 context: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.contentRuleList()
    }

    func loadWebView() {
        
        self.title = self.hasContentBlockers ? "Bloqueo Activado": "Sin Bloqueos"
        self.webView.load(request)
    }
    
    func contentRuleList() {
        
        WKContentRuleListStore.default().compileContentRuleList(
            forIdentifier: "ContentBlockingRules",
            encodedContentRuleList: Blocker.buildBlockedResources(addOptionals: true)) { (contentRuleList, error) in
                
                if let error = error {
                    debugPrint(error)
                    return
                }
                
                let configuration = self.webView.configuration
                configuration.userContentController.add(contentRuleList!)
                self.hasContentBlockers = true
                self.loadWebView()
        }
    }
    
    @IBAction func reloadWebView(_ sender: Any) {
        
        if self.hasContentBlockers {

            self.webView.configuration.userContentController.removeAllContentRuleLists()
            self.hasContentBlockers = false
            
            self.loadWebView()
        } else {
            
            self.contentRuleList()
        }
    }
    
    //observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}
