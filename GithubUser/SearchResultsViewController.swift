//
//  ViewController.swift
//  HelloWorld
//
//  Created by Michael Nikitochkin on 8/9/14.
//  Copyright (c) 2014 JetThoughts. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, APIControllerProtocol {
    let kCellIdentifier: String = "SearchResultCell"
    var tableData = []
    var api = APIController()
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
        
        cell.detailTextLabel.text = url
        
        return cell    }
    
    override func viewDidLoad() {
        self.api.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api.searchUserFor("miry")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveAPIResults(resultsArr: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = resultsArr
            self.appsTableView!.reloadData()
        })
    }


}

