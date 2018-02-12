//
//  THImageCacheManager.swift
//  THTiledImageView
//
//  Created by 홍창남 on 2018. 2. 8..
//  Copyright © 2018년 홍창남. All rights reserved.
//

import Foundation
import Kingfisher

typealias THImageDownloaderCompletion = (UIImage, URL) -> Void
typealias THImageCacheCompletion = () -> Void

protocol THImageManager {
    func downloadEachTiles(path: URL, completion: @escaping THImageDownloaderCompletion)
    func cacheEachTiles(completion: @escaping THImageDownloaderCompletion)

}

protocol THImageDownloaderDelegate {

}

class THImageDownloadManager {

    static let `default` = THImageDownloadManager()

    func downloadEachTiles(path url: URL, completion: @escaping THImageDownloaderCompletion) {

        ImageDownloader.default.downloadImage(with: url, retrieveImageTask: nil,
                                              options: [], progressBlock: nil) { (image, error, url, _) in
            if let error = error {
                print(error)
                return
            }

            print("Downloaded Image \(String(describing: image))")
            guard let image = image else { return }
            guard let url = url else { return }

            completion(image, url)
        }
    }

}

class THImageCacheManager {

    static let `default` = THImageCacheManager()

    func cacheTiles(image: UIImage, imageIdentifier: String, completion: @escaping THImageCacheCompletion) {
        ImageCache.default.store(image, original: nil, forKey: imageIdentifier) {
            completion()
        }
    }

//    func retrieveTiles(key: String, completion: @escaping THImageCacheCompletion) {
//        ImageCache.default.retrieveImage(forKey: key, options: nil) {  image, _ in
//            if let image = image {
//                completion(image)
//            }
//        }
//    }

}
