//
//  ViewController.swift
//  MyTileImageViewer
//
//  Created by 홍창남 on 2017. 12. 28..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tileImageScrollView: TileImageScrollView!
    var dataSource: TileImageViewDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        let tiles: [CGSize] = [CGSize(width: 2048, height: 2048), CGSize(width: 1024, height: 1024), CGSize(width: 512, height: 512), CGSize(width: 256, height: 256), CGSize(width: 128, height: 128)]

        UIImage.saveTileOfSize(tiles, name: "bench")
        let imageSize = CGSize(width: 5214, height: 7300)
        let imageURL = Bundle.main.url(forResource: "smallBench", withExtension: "jpg")!

        setupExample(imageSize: imageSize, tileSize: tiles, imageURL: imageURL)
    }

    func setupExample(imageSize: CGSize, tileSize: [CGSize], imageURL: URL) {

        dataSource = MyTileImageViewDataSource(imageSize: imageSize, tileSize: tileSize, imageURL: imageURL)
        dataSource?.imageName = "bench"

        // 줌을 가장 많이 확대한 수준
        dataSource?.maxTileLevel = 5

        // 줌이 가장 확대가 안 된 수준
        dataSource?.minTileLevel = 1
        tileImageScrollView.set(dataSource: dataSource!)

        dataSource?.requestBackgroundImage { _ in

        }
    }

    func dummy() {
//        UIImage.saveTileOfSize(tileSize, name: "windingRoad")
//        let imageSize = CGSize(width: 5120, height: 3200)

//        let imageURL = Bundle.main.url(forResource: "large", withExtension: "jpg", subdirectory: "SenoraSabasaGarcia", localization: nil)!
//        let imageURL = Bundle.main.url(forResource: "bench", withExtension: "jpg")!
//        let imageURL = Bundle.main.url(forResource: "windingRoad", withExtension: "jpg")!
//        let imageURL = URL(string: "https://dl.dropbox.com/s/t1xwici6yuxplo0/bench.jpg")!

    }
}

extension UIImage {
    class func saveTileOfSize(_ size: [CGSize], name: String) {

        let levels = size.enumerated().map { (idx, _) in
            return idx + 1
        }

        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String

        let fileManager = FileManager.default
        let imageNamePath = "\(cachesPath)/\(name)"

        if !fileManager.fileExists(atPath: imageNamePath) {
            do {
                // Create Container Directory
                try fileManager.createDirectory(atPath: imageNamePath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)")
            }
        } else {
            return
        }

        size.enumerated().forEach { (idx, imageSize) in

            let imageDefaultPath = "\(imageNamePath)/\(Int(imageSize.width))"
            let filePath = "\(imageDefaultPath)/\(name)_\(Int(imageSize.width))_\(levels[idx])_0_0.png"
            let fileExists = fileManager.fileExists(atPath: filePath)

            if fileExists == false {
                do {
                    // Create Directory By Size
                    try fileManager.createDirectory(atPath: imageDefaultPath,
                                                    withIntermediateDirectories: false, attributes: nil)

                } catch let error as NSError {
                    print("Error creating directory: \(error.localizedDescription)")
                }

                var tileSize = imageSize
                let defaultTileSize = tileSize.width
                let scale = Float(UIScreen.main.scale)

                if let image = UIImage(named: "\(name).jpg") {
                    let imageRef = image.cgImage
                    let totalColumns = Int(ceilf(Float(image.size.width / tileSize.width)) * scale)
                    let totalRows = Int(ceilf(Float(image.size.height / tileSize.height)) * scale)
                    let partialColumnWidth = Int(image.size.width.truncatingRemainder(dividingBy: tileSize.width))
                    let partialRowHeight = Int(image.size.height.truncatingRemainder(dividingBy: tileSize.height))

                    DispatchQueue.global(qos: .default).async {
                        for y in 0..<totalRows {
                            tileSize = imageSize
                            for x in 0..<totalColumns {
                                if partialRowHeight > 0 && y + 1 == totalRows {
                                    tileSize.height = CGFloat(partialRowHeight)
                                }

                                if partialColumnWidth > 0 && x + 1 == totalColumns {
                                    tileSize.width = CGFloat(partialColumnWidth)
                                }

                                let xOffset = CGFloat(x) * defaultTileSize
                                let yOffset = CGFloat(y) * defaultTileSize
                                let point = CGPoint(x: xOffset, y: yOffset)

                                if let tileImageRef = imageRef?.cropping(to: CGRect(origin: point, size: tileSize)),
                                    let imageData = UIImagePNGRepresentation(UIImage(cgImage: tileImageRef)) {
                                    let path = "\(imageDefaultPath)/\(name)_\(Int(imageSize.width))_\(levels[idx])_\(x)_\(y).png"
                                    try? imageData.write(to: URL(fileURLWithPath: path), options: [])
                                }
                            }
                        }

                        print("\(imageSize.width) image cutting finish")
                    }
                }
            }

        }
    }

}
