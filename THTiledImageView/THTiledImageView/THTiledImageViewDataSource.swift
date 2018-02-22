//
//  THTiledImageViewDataSource.swift
//  THTiledImageViewDataSource
//
//  Created by 홍창남 on 2017. 12. 28..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

public protocol THTiledImageScrollViewDelegate: class {
    func didScroll(scrollView: THTiledImageScrollView)
    func didZoom(scrollView: THTiledImageScrollView)
}

public protocol THTiledImageViewDataSource: class {

    var delegate: THTiledImageScrollViewDelegate? { get set }

    // full Image size
    var originalImageSize: CGSize { get set }

    // TileLayer
    var tileSize: [CGSize] { get set }
    var minTileLevel: Int { get set }
    var maxTileLevel: Int { get set }

    // Default Zoom Level is Scale Aspect Fit Size.
    // MaxZoomLevel allow you to zoom in image to its level.
    var maxZoomLevel: CGFloat? { get set }

    // ThumbNail Image Name
    // This will be used as a thumbnail of image
    // You need to set thumbnail image ratio same as original image
    var thumbnailImageName: String { get set }

    // Image Info
    var tileImageBaseURL: URL? { get set }
    var imageExtension: String { get set }

    var backgroundImage: UIImage? { get set }
    var backgroundImageURL: URL? { get set }

    var accessFromServer: Bool { get set }

    // Set BackgroundImage From Remote URL
    func requestBackgroundImage(completionHandler: @escaping (UIImage?) -> Void)

    // Use Local Background Image
    func setBackgroundImage(url: URL)
}

extension THTiledImageViewDataSource {
    var contentSize: CGSize {
        return self.originalImageSize
    }

    func requestBackgroundImage(completionHandler: @escaping (UIImage?) -> Void) {
        guard let url = self.backgroundImageURL else {
            return
        }

        let session = URLSession(configuration: .default)
        let request = URLRequest(url: url)

        let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            guard let response = response as? HTTPURLResponse else { return }

            switch response.statusCode {
            case 200:
                if let data = data, let image = UIImage(data: data) {
                    self.backgroundImage = image
                    completionHandler(image)
                }
            default:
                completionHandler(nil)
            }
        }
        dataTask.resume()
    }

    func setBackgroundImage(url: URL) {
        if let image = UIImage(contentsOfFile: url.path) {
            self.backgroundImage = image
        }
    }
}
