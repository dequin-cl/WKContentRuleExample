//
//  Blocker.swift
//  Filtering WkView
//
//  Created by Iván Antonio Galaz Jeria on 02-01-18.
//  Copyright © 2018 dequin. All rights reserved.
//

import UIKit

class Blocker {

    fileprivate static let resourceToBlockPattern = """
    {
        "trigger": {
            "url-filter": ""
        },
        "action": {
            "type": "block"
        }
    }
    """
    
    fileprivate static let resourceToAvoidBlockPattern = """
    {
        "trigger": {
            "url-filter": ""
        },
        "action": {
            "type": "ignore-previous-rules"
        }
    }
    """
    
    fileprivate static let blockedResources =
    [
        "http.?://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js",
        "http.?://cdn.sstatic.net/Sites/stackoverflow/all.css*"
    ]
    
    fileprivate static let optionalResources =
    [
        ".*.png",
        ".*.jpg",
        ".*.gif",
        ".*.jpeg",
        ".*.css"
    ]
    
    /**
     Method to build a list of rules to block content. It uses an internal list (blockedResources)
     and if you choose to you can also block the optionals internal list (optionalResources)
     
     - important: Make sure you read this file. It contains the Rules patterns
     - returns: a String containing the list of Content Rules
     - parameter addOptionals: Should block the optional resources
     
     */
    static func buildBlockedResources(addOptionals: Bool) -> String {
        
        var blockedResourcesConcatenatedList = ""
        
        let listsToBlock = addOptionals ? [blockedResources, optionalResources]: [blockedResources]
        
        for elementListToBlock in listsToBlock {
            
            for blockedResource in elementListToBlock {
                
                var jsonAny = resourceToBlockPattern.parseJSONString as! [String:Any]
                
                var trigger = jsonAny["trigger"] as! [String:Any]
                trigger["url-filter"] = blockedResource
                
                
                jsonAny["trigger"] = trigger
                
                if !blockedResourcesConcatenatedList.isEmpty {
                    
                    blockedResourcesConcatenatedList.append(",")
                }
                blockedResourcesConcatenatedList.append(stringify(json: jsonAny))
            }
        }

        return "[\(blockedResourcesConcatenatedList)]"
    }
    
    fileprivate static func stringify(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
            options = JSONSerialization.WritingOptions.prettyPrinted
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: options)
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                return string
            }
        } catch {
            print(error)
        }
        
        return ""
    }
}

fileprivate extension String {
    
    var parseJSONString: AnyObject? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            do {
                
                return try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
            } catch {
                debugPrint(error)
                return nil
            }
            
            
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}
