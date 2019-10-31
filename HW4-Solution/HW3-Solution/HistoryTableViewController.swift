//
//  HistoryTableViewController.swift
//  HW3-Solution
//
//  Created by Xcode User on 10/28/19.
//  Copyright © 2019 Jonathan Engelsma. All rights reserved.
//

import Foundation
import UIKit

class HistoryTableViewController: UITableViewController{

    @IBOutlet var historyTableView: UITableView!
    
    var entries : [Conversion]? = []
    
    //var tableViewData: [(sectionHeader: String, entries: [Conversion])]? {
    //    didSet {
    //        DispatchQueue.main.async {
    //            self.historyTableView.reloadData()
    //        }
    //    }
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.sortIntoSections(entries: (self.entries)!)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return self.tableViewData?.count ?? 0
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.tableViewData?[section].entries.count ?? 0
        
        if let entry = self.entries{
            return entry.count
        }
        else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        //guard let entry =
        //    tableViewData?[indexPath.section].entries[indexPath.row] else {
        //        return cell
       // }
        
        //let dateFormatter = DateFormatter()
        
        if let entry = self.entries?[indexPath.row]{
            cell.textLabel?.text = String(entry.fromVal) + " " + entry.fromUnits + " = " + String(entry.toVal) + " " + entry.toUnits
            cell.detailTextLabel?.text = entry.timestamp.short
        }
        
//        guard let entry = tableViewData?[indexPath.section].entries[indexPath.row]
//            else {
//                return cell
//        }
//
//        let text1 = String(entry.fromVal) + " " + entry.fromUnits + " = " + String(entry.toVal) + " " + entry.toUnits
//        //let text2 = String(entry.timestamp)
//        let text2 = "whoop"
//
//        cell.textLabel?.text = text1
//        cell.detailTextLabel?.text = text2
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let entry = tableViewData?[indexPath.section].entries[indexPath.row] else {
            return
        }
        print("Selected\(String(describing: entry.fromUnits))")
    }
    
    
    //Code added for part 2
    var tableViewData: [(sectionHeader: String, entries: [Conversion])]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func sortIntoSections(entries: [Conversion]) {
        var tmpEntries: Dictionary<String,[Conversion]> = [:]
        var tmpData: [(sectionHeader: String, entries: [Conversion])] = []
        
        //partition into sections
        for entry in entries {
            let shortDate = entry.timestamp.short
            if var bucket = tmpEntries[shortDate] {
                bucket.append(entry)
                tmpEntries[shortDate] = bucket
            }
            else {
                tmpEntries[shortDate] = [entry]
            }
        }
    
        //breakout into our preferred array format
        let keys = tmpEntries.keys
        for key in keys {
            if let val = tmpEntries[key] {
                tmpData.append((sectionHeader: key, entries: val))
            }
        }
        
        //sort by increasing date
        tmpData.sort{ (v1, v2) -> Bool in
            if v1.sectionHeader < v2.sectionHeader {
                return true
            }
            else {
                return false
            }
        }
        
        self.tableViewData = tmpData
    }
    
    
}

protocol HistoryTableViewControllerDelegate {
    func selectEntry(entry: Conversion)
}

extension Date {
    struct Formatter {
        static let short: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    }
    
    var short: String {
        return Formatter.short.string(from: self)
    }
}
