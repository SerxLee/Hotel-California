//
//  KeyViewController.swift
//  JiaGeXianForiPone
//
//  Created by Serx on 2/2/16.
//  Copyright © 2016 serx. All rights reserved.
//

import UIKit

protocol KeyViewControllerDelegate{
    
    func closekeyView(String)
}

class KeyViewController: UITableViewController {
    
    var keyTypeList: [AnyObject]!
    
    var keyDict: [String: AnyObject]!
    var delegate:KeyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.keyTypeList = Array(self.keyDict.keys)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.keyDict.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let keyName = self.keyTypeList[section] as! String
        let keylist = self.keyDict[keyName] as! [AnyObject]
        return self.keyTypeList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let keyName = self.keyTypeList[indexPath.section] as! String
        let keyList = self.keyDict[keyName] as! [AnyObject]
        
        let dict = keyList[indexPath.row] as! [String: String]
        
        cell.textLabel?.text = dict["key"]
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let keyName = self.keyTypeList[section] as! String
        return keyName
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
        return Array(self.keyDict.keys)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let keyName = self.keyTypeList[indexPath.section] as! String
        let keyList = self.keyDict[keyName] as! [AnyObject]
        let dict = keyList[indexPath.row] as [String: String]
        
        self.delegate?.closekeyView(dict["key"])
    }
}
