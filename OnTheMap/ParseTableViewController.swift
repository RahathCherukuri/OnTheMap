//
//  ParseTableViewController.swift
//  OnTheMap
//
//  Created by Rahath cherukuri on 2/22/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

import UIKit

class ParseTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getStudentInformation()
    }
    
    
    @IBAction func logOutButtonAction(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().deleteSession(){ (success, id, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(),{
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(),{
                    self.showAlertView(errorString!)
                })
            }
        }
    }
    
    @IBAction func postInformation(sender: UIBarButtonItem) {
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("PostInformationViewController") as! PostInformationViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonAction(sender: UIBarButtonItem) {
        getStudentInformation()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if StudentInfo.studentInfo.count == 0 {
            getStudentInformation()
        }
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
        guard let url = NSURL(string:toOpen) as NSURL? else {
            showAlertView("Invalid Link")
            return
        }
        app.openURL(url)
    }
    
    func getStudentInformation() {
        ParseClient.sharedInstance().getstudentInformation () { (success, results, errorString) in
            if success {
                ParseClient.sharedInstance().parseResultsAndSaveInStudentInfo(results!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            } else {
                dispatch_async(dispatch_get_main_queue(),{
                    self.showAlertView(errorString!)
                })
            }
        }
    }
    
    func showAlertView(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let dismiss = UIAlertAction (title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(dismiss)
        self.presentViewController(alert, animated: true, completion: nil)
    }
 
}
