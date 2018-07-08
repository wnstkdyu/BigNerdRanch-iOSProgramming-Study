//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Alpaca on 2018. 7. 8..
//  Copyright © 2018년 Alpaca. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore?
    
    let cellReuseIdentifier: String = "UITableViewCell"
    let noMoreItemsString: String = "No more items!"
    
    let sections: [String] = ["Above $50", "ETC"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
}

extension ItemsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let itemStore = itemStore else { return 0 }
        let cellCount: Int
        switch section {
        case 0:
            cellCount = itemStore.expensiveItems.count
        case 1:
            cellCount = itemStore.cheapItems.count
        default:
            cellCount = 0
        }
        
        return cellCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        guard indexPath.row < (itemStore?.allItems.count)! else {
            cell.textLabel?.text = noMoreItemsString
            
            return cell
        }
        
        let item: Item?
        switch indexPath.section {
        case 0:
            item = itemStore?.expensiveItems[indexPath.row]
        case 1:
            item = itemStore?.cheapItems[indexPath.row]
        default:
            item = nil
        }
        
        cell.textLabel?.text = item?.name
        cell.detailTextLabel?.text = "$\(item?.valueInDollars ?? 0)"
        
        return cell
    }
}
