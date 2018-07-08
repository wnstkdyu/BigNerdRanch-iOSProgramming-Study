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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
}

extension ItemsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let itemStore = itemStore else { return 0 }
        
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        let item = itemStore?.allItems[indexPath.row]
        
        cell.textLabel?.text = item?.name
        cell.detailTextLabel?.text = "$\(item?.valueInDollars ?? 0)"
        
        return cell
    }
}
