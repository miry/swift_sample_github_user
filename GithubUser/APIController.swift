//
//  APIController.swift
//  GithubUser
//
//  Created by Michael Nikitochkin on 8/9/14.
//  Copyright (c) 2014 JetThoughts. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSArray)
}

class APIController {
    
    var delegate: APIControllerProtocol
    
    init(delegate: APIControllerProtocol) {
        self.delegate = delegate
    }
    
    func searchUserFor(searchTerm: String) {
        
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        println("Search by: \(itunesSearchTerm)")
        
        // Now escape anything else that isn't URL-friendly
        let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        //        let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
        let urlPath = "https://api.github.com/search/users?q=\(escapedSearchTerm)"
        let url: NSURL = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if(error) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if(err != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            let results: NSArray = jsonResult["items"] as NSArray
            self.delegate.didReceiveAPIResults(results)
        })
        task.resume()
    }

}