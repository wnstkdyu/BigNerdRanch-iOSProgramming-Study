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
    
    init() {
        for _ in 0..<5 {
            createItem()
        }
    }
    
    @discardableResult func createItem() -> Item {
        let newItem: Item = Item(random: true)
        allItems.append(newItem)
        
        return newItem
    }
}
