//
//  THTiledImageView.swift
//  THTiledImageView
//
//  Created by 홍창남 on 2017. 12. 30..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

class TiledLayer: CATiledLayer {

    static var tileFadeDuration: CFTimeInterval = 0.0

    override class func fadeDuration() -> CFTimeInterval {
        return self.tileFadeDuration
    }

    class func setFadeDuration(_ duration: CFTimeInterval) {
        tileFadeDuration = duration
    }
}

class THTiledImageView: UIView {

    let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String

    var dataSource: THTiledImageViewDataSource?

    override class var layerClass: AnyClass {
        return TiledLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(dataSource: THTiledImageViewDataSource) {
        self.init(frame: CGRect(origin: CGPoint.zero, size: dataSource.originalImageSize))

        guard let layer = self.layer as? TiledLayer else { return }

        let scale = UIScreen.main.scale
        layer.contentsScale = scale

        let min = dataSource.minTileLevel
        let max = dataSource.maxTileLevel

        layer.levelsOfDetail = max - min + 1

        let tileSize = dataSource.tileSize
        layer.tileSize = tileSize[0]

        frame = CGRect(origin: CGPoint.zero, size: dataSource.originalImageSize)
    }

    override func draw(_ rect: CGRect) {
        guard let tileSize = dataSource?.tileSize else { return }

        var level: Int = 1

        let context = UIGraphicsGetCurrentContext()!
        let scaleX = context.ctm.a / UIScreen.main.scale

        let x = round(log2(Double(scaleX)))

        if let l = dataSource?.maxTileLevel {
            level = l + Int(x)
        }

        let length = tileSize[level - 1].width

        let firstColumn = Int(rect.minX / length)
        let lastColumn = Int(rect.maxX / length)
        let firstRow = Int(rect.minY / length)
        let lastRow = Int(rect.maxY / length)

        for row in firstRow...lastRow {
            for column in firstColumn...lastColumn {
                if let tile = imageForTileAtColumn(column, row: row, level: level) {
                    let x = length * CGFloat(column)
                    let y = length * CGFloat(row)
                    let point = CGPoint(x: x, y: y)
                    let size = tileSize

                    var tileRect = CGRect(origin: point, size: size[level - 1])

                    tileRect = self.bounds.intersection(tileRect)
                    tile.draw(in: tileRect)
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func imageForTileAtColumn(_ column: Int, row: Int, level: Int) -> UIImage? {
        let size = Int(dataSource!.tileSize[level - 1].width)
        let filePath = "\(cachesPath)/" +
                       "\(dataSource!.thumbnailImageName)/\(size)/" +
                       "\(dataSource!.thumbnailImageName)_\(size)_" +
                       "\(level)_\(column)_\(row).\(dataSource!.imageExtension)"

        return UIImage(contentsOfFile: filePath)
    }
}
