//
//  THTiledImageView.swift
//  THTiledImageView
//
//  Created by 홍창남 on 2017. 12. 30..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

struct THTile {
    var tileImage: UIImage
    var tileRect: CGRect
}

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

    var requestDict: [String: Bool] = [:]

    override class var layerClass: AnyClass {
        return TiledLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = UIViewContentMode.redraw
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
        guard let dataSource = dataSource else { return }

        let tileSize = dataSource.tileSize

        var level: Int = 1

        if let context = UIGraphicsGetCurrentContext() {
            let scaleX = context.ctm.a / UIScreen.main.scale
            let x = round(log2(Double(scaleX)))
            level = dataSource.maxTileLevel + Int(x)
        } else {
            let scaleX: CGFloat = 0.25
            let x = round(log2(Double(scaleX)))
            level = dataSource.maxTileLevel + Int(x)
        }

        let length = tileSize[level - 1].width

        let firstColumn = Int(rect.minX / length)
        let lastColumn = Int(rect.maxX / length)
        let firstRow = Int(rect.minY / length)
        let lastRow = Int(rect.maxY / length)

        for row in firstRow...lastRow {
            for column in firstColumn...lastColumn {

                let x = length * CGFloat(column)
                let y = length * CGFloat(row)
                let point = CGPoint(x: x, y: y)
                let size = tileSize
                var tileRect = CGRect(origin: point, size: size[level - 1])
                DispatchQueue.main.async {
                    tileRect = self.bounds.intersection(tileRect)
                }

                if let tile = imageForTileAtColumn(imageSize: size[level - 1], tileRect: tileRect, column, row: row, level: level) {
                    tile.tileImage.draw(in: tileRect)
                } else {
                    if dataSource.accessFromServer {
                        // download image and redraw
                        DispatchQueue.main.async {
                            guard let baseURL = dataSource.tileImageBaseURL else {
                                fatalError("TileImage Base URL does not exists. You need to set tile image base url of dataSource.")
                            }
                            self.downloadAndRedrawImages(imageSize: size[level - 1], baseURL: baseURL,
                                                tileRect: tileRect, column, row: row, level: level)
                        }
                    }
                }
            }
        }
    }

    private func imageForTileAtColumn(imageSize: CGSize, tileRect: CGRect, _ column: Int, row: Int, level: Int) -> THTile? {
        guard let dataSource = dataSource else { return nil }

        let sizeInt = Int(imageSize.width)
        let imageKey = dataSource.thumbnailImageName + "_\(sizeInt)_\(level)_\(column)_\(row).\(dataSource.imageExtension)"

        if let image = THImageCacheManager.default.retrieveTiles(key: imageKey) {
            return THTile(tileImage: image, tileRect: tileRect)
        } else {
            DispatchQueue.main.async {
                self.layer.isOpaque = false
            }
            return nil
        }
    }

    private func downloadAndRedrawImages(imageSize: CGSize, baseURL: URL, tileRect: CGRect, _ column: Int, row: Int, level: Int) {
        guard let dataSource = dataSource else { return }

        let sizeInt = Int(imageSize.width)
        let imageNameWithSize = dataSource.thumbnailImageName + "_\(sizeInt)_\(level)_\(column)_\(row)"
        let imageKey = dataSource.thumbnailImageName + "_\(sizeInt)_\(level)_\(column)_\(row).\(dataSource.imageExtension)"
        let downloadPath = baseURL.appendingPathComponent("\(sizeInt)").appendingPathComponent(imageNameWithSize)

        if requestDict[imageKey] == nil {
            requestDict.updateValue(true, forKey: imageKey)

            THImageDownloadManager.default.downloadEachTiles(path: downloadPath) { image, _, error in
                if let error = error {
                    print(error)
                }
                if let image = image {
                    THImageCacheManager.default.cacheTiles(image: image, imageIdentifier: imageKey) {
                        let tile = THTile(tileImage: image, tileRect: tileRect)
                        self.layer.setNeedsDisplay(tile.tileRect)

                    }
                }
            }
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
