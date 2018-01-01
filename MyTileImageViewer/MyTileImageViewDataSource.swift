//
//  MyTileImageViewDataSource.swift
//  MyTileImageViewer
//
//  Created by 홍창남 on 2017. 12. 30..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

class MyTileImageViewDataSource: TileImageViewDataSource {

    var imageSize: CGSize
    var tileSize: CGSize

    var maxZoomLevel: CGFloat?

    var backgroundImageURL: URL
    var backgroundImage: UIImage

    init(imageSize: CGSize, tileSize: CGSize, imageURL: URL) {
        self.imageSize = imageSize
        self.tileSize = tileSize
        self.backgroundImageURL = imageURL
        self.backgroundImage = UIImage()
    }

    func requestBackgroundImage(completion: @escaping (UIImage?) -> Void) {

        if backgroundImageURL.absoluteString.contains("https") {
            // Server
            let session = URLSession(configuration: .default)
            let request = URLRequest(url: backgroundImageURL)

            let dataTask = session.dataTask(with: request) { data, response, error in
                guard error == nil else { return }
                guard let response = response as? HTTPURLResponse else { return }

                switch response.statusCode {
                case 200:
                    if let data = data, let image = UIImage(data: data) {
                        self.backgroundImage = image
                        completion(self.backgroundImage)
                    }
                default:
                    completion(nil)
                }
            }
            dataTask.resume()
        } else {
            // Local
            self.backgroundImage = UIImage(contentsOfFile: backgroundImageURL.path)!
            completion(self.backgroundImage)
        }

    }

}
