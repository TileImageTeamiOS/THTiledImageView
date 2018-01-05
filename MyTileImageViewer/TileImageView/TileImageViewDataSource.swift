//
//  TileImageViewDataSource.swift
//  MyTileImageViewer
//
//  Created by 홍창남 on 2017. 12. 28..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

public protocol TileImageViewDataSource: class {

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
    var imageURL: URL { get set }
    var image: UIImage { get set }

    // Set BackgroundImage From URL
    func requestBackgroundImage(completion: @escaping (UIImage?) -> Void)

}

extension TileImageViewDataSource {

    var contentSize: CGSize {
        return self.originalImageSize
    }
}
