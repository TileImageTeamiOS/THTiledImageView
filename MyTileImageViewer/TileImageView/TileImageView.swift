//
//  TileImageView.swift
//  MyTileImageViewer
//
//  Created by 홍창남 on 2017. 12. 30..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

class TileImageView: UIView {

    let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String

    var dataSource: TileImageViewDataSource?

    override class var layerClass: AnyClass {
        return CATiledLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func draw(_ rect: CGRect) {
        guard let tileSize = dataSource?.tileSize else { return }
        let length = tileSize.width

        let firstColumn = Int(rect.minX / length)
        let lastColumn = Int(rect.maxX / length)
        let firstRow = Int(rect.minY / length)
        let lastRow = Int(rect.maxY / length)

        for row in firstRow...lastRow {
            for column in firstColumn...lastColumn {
                if let tile = imageForTileAtColumn(column, row: row) {
                    let x = length * CGFloat(column)
                    let y = length * CGFloat(row)
                    let point = CGPoint(x: x, y: y)
                    let size = tileSize

                    var tileRect = CGRect(origin: point, size: size)

                    tileRect = bounds.intersection(tileRect)
                    tile.draw(in: tileRect)
                }
            }
        }
    }

    convenience init(imageSize: CGSize) {
        self.init(frame: CGRect(origin: CGPoint.zero, size: imageSize))

        guard let layer = self.layer as? CATiledLayer else { return }

        let scale = UIScreen.main.scale
        layer.contentsScale = scale
        if let tileSize = dataSource?.tileSize {
            layer.tileSize = tileSize
        }

        frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func imageForTileAtColumn(_ column: Int, row: Int) -> UIImage? {
        let filePath = "\(cachesPath)/\(dataSource!.imageName)_\(column)_\(row)"
        print("\(dataSource!.imageName)_\(column)_\(row)")
        return UIImage(contentsOfFile: filePath)
    }
}
