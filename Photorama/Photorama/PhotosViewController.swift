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
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store?.fetchInterestingPhotos{ photosResult in
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos.")
                if let firstPhoto = photos.first {
                    self.updateImageView(for: firstPhoto)
                }
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
        }
    }
    
    func updateImageView(for photo: Photo) {
        store?.fetchImage(for: photo) { [weak self] imageResult in
            switch imageResult {
            case let .success(image):
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        } }
}
