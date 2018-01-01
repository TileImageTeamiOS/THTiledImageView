//
//  TileImageView.swift
//  MyTileImageViewer
//
//  Created by 홍창남 on 2017. 12. 30..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

class TileImageView: UIView {

    var dataSource: TileImageViewDataSource?

    override class var layerClass: AnyClass {
        return CATiledLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        context?.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.fill(rect)
    }

    convenience init(imageSize: CGSize) {
        self.init(frame: CGRect(origin: CGPoint.zero, size: imageSize))

        srand48(Int(Date().timeIntervalSince1970))
        guard let layer = self.layer as? CATiledLayer else { return }

        let scale = UIScreen.main.scale
        layer.contentsScale = scale
        if let tileSize = dataSource?.tileSize {
            layer.tileSize = tileSize
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
