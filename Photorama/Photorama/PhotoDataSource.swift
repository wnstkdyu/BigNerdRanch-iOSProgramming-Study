//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by Alpaca on 2018. 7. 11..
//  Copyright © 2018년 Alpaca. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject {
    
    var photos: [Photo] = []
    
    let cellIdentifer: String = "UICollectionViewCell"
}

extension PhotoDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifer, for: indexPath) as? PhotoCollectionViewCell ?? PhotoCollectionViewCell()
        
        let photo = photos[indexPath.item]
        cell.update(with: photo.image)
        
        return cell
    }
}
