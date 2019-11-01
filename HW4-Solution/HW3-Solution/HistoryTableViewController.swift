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
    
    var historyDelegate:HistoryTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.sortIntoSections(entries: (self.entries)!)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        //return self.tableViewData?.count ?? 0
        //return 1
        if let data=self.tableViewData {
            return data.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sectionInfo = self.tableViewData?[section] {
            return sectionInfo.entries.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FancyCell", for: indexPath) as! HistoryTableViewCell
        if let entry = self.tableViewData?[indexPath.section].entries[indexPath.row] {
            cell.conversionLabel.text = "\(entry.fromVal) \(entry.fromUnits) = \(entry.toVal) \(entry.toUnits)"
            cell.timestampLabel.text = "\(entry.timestamp.description)"
            cell.thumbnail.image = UIImage(imageLiteralResourceName: entry.mode == .Volume ? "volume_icon" : "length_icon")
        }
        return cell
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableViewData?[section].sectionHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView:UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = BACKGROUND_COLOR
        header.contentView.backgroundColor = FOREGROUND_COLOR
    }
    
    //USE AFTER HISTORY DELEGATE IS FIXED
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if let del = self.historyDelegate {
            if let conv = self.tableViewData?[indexPath.section].entries[indexPath.row] {
                del.selectEntry(entry: conv)
            }
        }
        _ = self.navigationController?.popViewController(animated: true)
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
