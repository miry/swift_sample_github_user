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

    var users = [Album]()

    var imageCache = [String : UIImage]()
//    var api = APIController()
    lazy var api : APIController = APIController(delegate: self)
    @IBOutlet weak var appsTableView: UITableView!

    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        let userRow: User = self.users[indexPath.row]
        let login: String? = userRow.login
        
        // Add a check to make sure this exists

        cell.textLabel.text = login
        
        // It seems IOS looks to all files, and choose by name.
        cell.imageView.image = UIImage(named: "miry.jpg")

        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        let urlString: NSString = rowData["avatar_url"] as NSString
        
        var image = self.imageCache[urlString]

        if (image == nil) {
            let imgURL: NSURL = NSURL(string: urlString)
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    // Store the image in to our cache
                    self.imageCache[urlString] = image
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                        cellToUpdate.imageView.image = image
                    }
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                    cellToUpdate.imageView.image = image
                }
            })
        }
        

        
        let url:String  = rowData["html_url"] as String
        
        cell.detailTextLabel.text = url
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        // Get the row data for the selected row
//        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
//        var alert: UIAlertView = UIAlertView()
//        
//        var score: Double = rowData["score"] as Double
//        alert.title = rowData["login"] as String
//        
//        alert.message = "Score is \(score)"
//        alert.addButtonWithTitle("Ok")
//        alert.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.searchUserFor("miry")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveAPIResults(resultsArr: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.users = User.resultsArr
            self.appsTableView!.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var detailsViewController: DetailsViewController = segue.destinationViewController as DetailsViewController
        var userIndex = appsTableView!.indexPathForSelectedRow().row
        var selectedUser = self.users[userIndex]
        detailsViewController.user = selectedUser
    }

}

