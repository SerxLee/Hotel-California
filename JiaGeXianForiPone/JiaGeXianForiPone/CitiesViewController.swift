//
//  CitiesViewController.swift
//  JiaGeXianForiPone
//
//  Created by Serx on 2/2/16.
//  Copyright © 2016 serx. All rights reserved.
//

import UIKit

protocol CitiesViewControllerDelegate{
    
    func closeCitiesView(info: String)
}

class CitiesViewController: UITableViewController {
    //all the cities
    var cities: NSDictionary?
    var keyName: [String]!
    
    var delegate: CitiesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cityPlistPath = NSBundle.mainBundle().pathForResource("city", ofType: "plist")
        
        let bySpell = NSSortDescriptor(key: "fullname", ascending: true)
        
        self.cities = NSDictionary(contentsOfFile: cityPlistPath)
        self.keyName = NSDictionary(contentsOfFile: cityPlistPath)?.allKeys
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = keyName[indexPath.row]
        cell.detailTextLabel?.text = cities[keyName[indexPath.row]]["fullname"]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let ss = keyName[indexPath.row]
        self.delegate?.closeCitiesView(ss)
    }
}
