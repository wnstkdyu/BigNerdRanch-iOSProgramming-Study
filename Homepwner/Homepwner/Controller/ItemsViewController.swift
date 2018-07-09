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
    let segueIdentifier: String = "ShowItem"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == segueIdentifier,
            let row = tableView.indexPathForSelectedRow?.row else { return }
        let item = itemStore?.allItems[row]
        
        guard let detailViewController = segue.destination as? DetailViewController else { return }
        detailViewController.item = item
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        guard let newItem = itemStore?.createItem() else { return }
        
        if let index = itemStore?.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
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
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let item = itemStore?.allItems[indexPath.row] else { return }
            itemStore?.removeItem(item)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
