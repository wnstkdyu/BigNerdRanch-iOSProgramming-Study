//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Alpaca on 2018. 7. 11..
//  Copyright © 2018년 Alpaca. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    var store: PhotoStore?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        store?.fetchInterestingPhotos{ [weak self] photosResult in
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos.")
                self?.photoDataSource.photos = photos
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
                self?.photoDataSource.photos.removeAll()
            }
            
            self?.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto"?:
            if let selectedIndexPath =
                collectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                guard let destinationVC = segue.destination as? PhotoInfoViewController else { return }
                destinationVC.photo = photo
                destinationVC.store = store
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.item]
        store?.fetchImage(for: photo) { [weak self] result in
            guard let photoIndex = self?.photoDataSource.photos.index(of: photo),
                case let .success(image) = result else {
                    return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            
            if let cell = self?.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                cell.update(with: image)
            }
        }
    }
}


