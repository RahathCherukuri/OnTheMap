//
//  ParseTableViewController.swift
//  OnTheMap
//
//  Created by Rahath cherukuri on 2/22/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

import UIKit

class ParseTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getStudentInformation()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInfo.studentInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("parseCell")
        
        let fullname = StudentInfo.studentInfo[indexPath.row].firstName + StudentInfo.studentInfo[indexPath.row].lastName

        cell?.textLabel?.text = fullname
        cell?.detailTextLabel?.text = StudentInfo.studentInfo[indexPath.row].mediaURL
        return cell!
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        let toOpen = StudentInfo.studentInfo[indexPath.row].mediaURL
        app.openURL(NSURL(string:toOpen)!)
    }
    
    func getStudentInformation() {
        ParseClient.sharedInstance().getstudentInformation () { (success, results, errorString) in
            if success {
                print("success: ", success)
                ParseClient.sharedInstance().parseResultsAndSaveInStudentInfo(results!)
            } else {
                print("errorString: ", errorString)
            }
        }
    }
    
}
