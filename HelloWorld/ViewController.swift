//
//  ViewController.swift
//  HelloWorld
//
//  Created by Michael Nikitochkin on 8/9/14.
//  Copyright (c) 2014 JetThoughts. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    var tableData = []
    @IBOutlet weak var appsTableView: UITableView!
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        let rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
    
        let login:String = rowData["login"] as String
        
    
        cell.textLabel.text = login
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        let urlString: NSString = rowData["avatar_url"] as NSString
        let imgURL: NSURL = NSURL(string: urlString)
        
        // Download an NSData representation of the image at the URL
        let imgData: NSData = NSData(contentsOfURL: imgURL)
        cell.imageView.image = UIImage(data: imgData)
        
        // Get the formatted price string for display in the subtitle
        let url:String  = rowData["html_url"] as String
        println("url: \(url)")
        
        cell.detailTextLabel.text = url
        
        return cell    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchItunesFor("miry")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchItunesFor(searchTerm: String) {
        
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
            dispatch_async(dispatch_get_main_queue(), {
                self.tableData = results
                self.appsTableView!.reloadData()
                })
            })
        task.resume()
    }

}

