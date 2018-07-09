//
//  ItemStore.swift
//  Homepwner
//
//  Created by Alpaca on 2018. 7. 8..
//  Copyright © 2018년 Alpaca. All rights reserved.
//

import Foundation

class ItemStore {
    
    var allItems: [Item] = []
    
    @discardableResult func createItem() -> Item {
        let newItem: Item = Item(random: true)
        allItems.append(newItem)
        
        return newItem
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.index(of: item) {
            allItems.remove(at: index)
        }
    }
}
