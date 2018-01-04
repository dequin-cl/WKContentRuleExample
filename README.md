# WKContentRuleExample
**Usage of WKContentRule to block content on WKWebView**

### Since iOS 11 you can use WKContentRuleList

## Define the rules
First, create a **Content Rule** or a list. Each rule is comprised of a trigger and an action. See [Apple's Documentation on Content Rule creation](https://developer.apple.com/library/content/documentation/Extensions/Conceptual/ContentBlockingRules/CreatingRules/CreatingRules.html)

This is a creation example, blocks all image and Style Sheet content, but allows those ended on jpeg by way of ignoring the previous rules:

     let blockRules = """
         [{
             "trigger": {
                 "url-filter": ".*",
                 "resource-type": ["image"]
             },
             "action": {
                 "type": "block"
             }
         },
         {
             "trigger": {
                 "url-filter": ".*",
                 "resource-type": ["style-sheet"]
             },
             "action": {
                 "type": "block"
             }
         },
         {
             "trigger": {
                 "url-filter": ".*.jpeg"
             },
             "action": {
                 "type": "ignore-previous-rules"
             }
         }]
      """        

## Add the rules to your WKWebView
Having your list of rules, you can add them to the **ContentRuleListStore**

    import WebKit
    @IBOutlet weak var wkWebView: WKWebView!

    let request = URLRequest(url: URL(string: "https://yourSite.com/")!)

    WKContentRuleListStore.default().compileContentRuleList(
        forIdentifier: "ContentBlockingRules",
        encodedContentRuleList: blockRules) { (contentRuleList, error) in

            if let error = error {
                return
            }

            let configuration = self.webView.configuration
            configuration.userContentController.add(contentRuleList!)

            self.wkWwebView.load(self.request)
    }
If later you want to remove all your rules, call:

    self.wkWebView.configuration.userContentController.removeAllContentRuleLists()
    self.wkWebView.load(self.request)
Here is the [2017 WWDC video](https://developer.apple.com/videos/play/wwdc2017/220/)
