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
        print("viewDidload")
    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(animated)
        getStudentInformation()
    }
    
    
    @IBAction func logOutButtonAction(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().deleteSession(){ (success, id, errorString) in
            if success {
                print("success: ", success)
                print("id: ", id)
                dispatch_async(dispatch_get_main_queue(),{
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                print("errorString: ", errorString)
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
        print(StudentInfo.studentInfo.count)
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
        print(StudentInfo.studentInfo[indexPath.row])
        let toOpen = StudentInfo.studentInfo[indexPath.row].mediaURL
        guard let url = NSURL(string:toOpen) as NSURL? else {
            return
        }
        app.openURL(url)
    }
    
    func getStudentInformation() {
        ParseClient.sharedInstance().getstudentInformation () { (success, results, errorString) in
            if success {
                print("success: ", success)
                ParseClient.sharedInstance().parseResultsAndSaveInStudentInfo(results!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            } else {
                print("errorString: ", errorString)
            }
        }
    }
 
}
