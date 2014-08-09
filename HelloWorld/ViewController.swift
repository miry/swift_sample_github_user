//
//  ViewController.swift
//  HelloWorld
//
//  Created by Michael Nikitochkin on 8/9/14.
//  Copyright (c) 2014 JetThoughts. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
                            
    @IBOutlet weak var appTableView: UITableView!
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        cell.textLabel.text = "Row #\(indexPath.row)"
        cell.detailTextLabel.text = "G Subtitle #\(indexPath.row)"
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

