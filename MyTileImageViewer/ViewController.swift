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

        // image 자르는 메소드
        let tileSize = CGSize(width: 512, height: 512)
//        UIImage.saveTileOfSize(tileSize, name: "windingRoad")
        UIImage.saveTileOfSize(tileSize, name: "bench")
        let imageSize = CGSize(width: 5214, height: 7300)

//        let imageSize = CGSize(width: 5120, height: 3200)

//        let imageURL = Bundle.main.url(forResource: "large", withExtension: "jpg", subdirectory: "SenoraSabasaGarcia", localization: nil)!
//        let imageURL = Bundle.main.url(forResource: "bench", withExtension: "jpg")!
        let imageURL = Bundle.main.url(forResource: "smallBench", withExtension: "jpg")!
//        let imageURL = Bundle.main.url(forResource: "windingRoad", withExtension: "jpg")!
//        let imageURL = URL(string: "https://dl.dropbox.com/s/t1xwici6yuxplo0/bench.jpg")!

        setupExample(imageSize: imageSize, tileSize: tileSize, imageURL: imageURL)
    }

    func setupExample(imageSize: CGSize, tileSize: CGSize, imageURL: URL) {

        dataSource = MyTileImageViewDataSource(imageSize: imageSize, tileSize: tileSize, imageURL: imageURL)
        dataSource?.imageName = "bench"
        tileImageScrollView.set(dataSource: dataSource!)

        dataSource?.requestBackgroundImage { _ in

        }
    }
}

extension UIImage {
    class func saveTileOfSize(_ size: CGSize, name: String) {
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String
        let filePath = "\(cachesPath)/\(name)_0_0.png"
        let fileManager = FileManager.default
        let fileExists = fileManager.fileExists(atPath: filePath)
        print(cachesPath)
        if fileExists == false {
            var tileSize = size
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
                        tileSize = size
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
                                let path = "\(cachesPath)/\(name)_\(x)_\(y).png"
                                try? imageData.write(to: URL(fileURLWithPath: path), options: [])
                            }
                        }
                    }
                    print("image cutting finish")
                }
            }
        }
    }

}
