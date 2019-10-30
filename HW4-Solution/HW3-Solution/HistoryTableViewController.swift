//
//  HistoryTableViewController.swift
//  HW3-Solution
//
//  Created by Xcode User on 10/28/19.
//  Copyright © 2019 Jonathan Engelsma. All rights reserved.
//

import Foundation
import UIKit

class HistoryTableViewController: UITableViewController {

    @IBOutlet var historyTableView: UITableView!
    
    var entries : [Conversion] = []
    
    var tableViewData: [(sectionHeader: String, entries: [Conversion])]? {
        didSet {
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableViewData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData?[section].entries.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        guard let entry = tableViewData?[indexPath.section].entries[indexPath.row]
            else {
                return cell
        }
        
        let text1 = String(entry.fromVal) + " " + entry.fromUnits + " = " + String(entry.toVal) + " " + entry.toUnits
        //let text2 = String(entry.timestamp)
        let text2 = "whoop"
        
        cell.textLabel?.text = text1
        cell.detailTextLabel?.text = text2
        
        return cell
    }
}
