//
//  PhotoStore.swift
//  Photorama
//
//  Created by Alpaca on 2018. 7. 11..
//  Copyright © 2018년 Alpaca. All rights reserved.
//

import UIKit

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}
enum PhotoError: Error {
    case imageCreationError
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        
        return URLSession(configuration: config)
    }()
    
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        guard let url = FlickrAPI.interestingPhotosURL else { return }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { [weak self] (data, _, error) in
            guard let result = self?.processPhotosRequest(data: data, error: error) else { return }
            completion(result)
        }
        task.resume()
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return FlickrAPI.photos(fromJSON: jsonData)
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        let task = session.dataTask(with: request) { [weak self] (data, _, error) -> Void in
            guard let result = self?.processImageRequest(data: data, error: error) else { return }
            completion(result)
        }
        task.resume()
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard let imageData = data,
            let image = UIImage(data: imageData) else {
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        
        return .success(image)
    }
}
