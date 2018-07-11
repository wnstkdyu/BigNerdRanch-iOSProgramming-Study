//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Alpaca on 2018. 7. 11..
//  Copyright © 2018년 Alpaca. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo? {
        didSet {
            navigationItem.title = photo?.title
        }
    }
    var store: PhotoStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let photo = photo else { return }
        store?.fetchImage(for: photo) { [weak self] result -> Void in
            switch result {
            case let .success(image):
                self?.imageView.image = image
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }
}
