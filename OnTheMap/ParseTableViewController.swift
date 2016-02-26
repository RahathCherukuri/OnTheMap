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
        print("view didload of ParseTableViewController")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(StudentInfo.studentInfo.count)
        return StudentInfo.studentInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("parseCell")
        
        let fullname = StudentInfo.studentInfo[indexPath.row].firstName + StudentInfo.studentInfo[indexPath.row].lastName

        cell?.textLabel!.text = fullname
        cell?.detailTextLabel?.text = StudentInfo.studentInfo[indexPath.row].mediaURL
        return cell!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.Delete {
//            Meme.memes.removeAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
//        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
//        detailController.selectedIndex = indexPath.row
//        navigationController!.pushViewController(detailController, animated: true)
    }

}
