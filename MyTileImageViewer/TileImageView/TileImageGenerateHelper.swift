//
//  TileImageGenerateHelper.swift
//  MyTileImageViewer
//
//  Created by 홍창남 on 2018. 1. 8..
//  Copyright © 2018년 홍창남. All rights reserved.
//


import UIKit

extension FileManager {
    static func createContainerDirectory(path: String) {

        if !FileManager.default.fileExists(atPath: path) {
            do {
                // Create Container Directory
                try FileManager.default.createDirectory(atPath: path,
                                                        withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)")
            }
        }
    }
}

extension UIImage {
    class func saveTileOf(size: [CGSize], name: String, withExtension: String) {

        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String

        let imageNameDirectoryPath = "\(cachesPath)/\(name)"

        print("Your Image file will be saved at : \(imageNameDirectoryPath)")

        FileManager.createContainerDirectory(path: imageNameDirectoryPath)

        let levels = size.enumerated().map { (idx, _) in
            return idx + 1
        }

        /*
         Path Rules ./imageName/imageSize/{imageName_imageSize_level_x_y}.jpg
         Example    ./bench/256/bench_256_1_0_0.jpg
         */

        size.enumerated().forEach { (idx, imageSize) in

            let imageSizeDirectoryPath = "\(imageNameDirectoryPath)/\(Int(imageSize.width))"

            // check file already exists
            let checkPath = "\(imageSizeDirectoryPath)/" +
                "\(name)_\(Int(imageSize.width))" +
            "_\(levels[idx])_0_0.\(withExtension)"

            let fileExists = FileManager.default.fileExists(atPath: checkPath)

            if fileExists == false {

                FileManager.createContainerDirectory(path: imageSizeDirectoryPath)

                var tileSize = imageSize
                let defaultTileSizeWidth = tileSize.width
                let defaultTileSizeHeight = tileSize.height

                let scale = Float(UIScreen.main.scale)

                if let image = UIImage(named: "\(name).\(withExtension)") {
                    guard let imageRef = image.cgImage else { return }

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

                                let xOffset = CGFloat(x) * defaultTileSizeWidth
                                let yOffset = CGFloat(y) * defaultTileSizeHeight
                                let point = CGPoint(x: xOffset, y: yOffset)

                                if let tileImageRef = imageRef.cropping(to: CGRect(origin: point, size: tileSize)) {

                                    let path = "\(imageSizeDirectoryPath)/" +
                                        "\(name)_\(Int(imageSize.width))" +
                                    "_\(levels[idx])_\(x)_\(y).\(withExtension)"

                                    generateImage(tileImageRef: tileImageRef, path: path, withExtension: withExtension)
                                }
                            }
                        }
                        print("\(imageSize.width) image cutting finish")
                    }
                }
            }
        }
    }

    static func generateImage(tileImageRef: CGImage, path: String, withExtension: String) {
        switch withExtension {
        case "jpg":
            if let imageData = UIImageJPEGRepresentation(UIImage(cgImage: tileImageRef), 1) {
                try? imageData.write(to: URL(fileURLWithPath: path), options: [])
            } else {
                print("UIImageJPEGRepresentation fail")
            }
        default:

            if let imageData = UIImagePNGRepresentation(UIImage(cgImage: tileImageRef)) {
                try? imageData.write(to: URL(fileURLWithPath: path), options: [])
            } else {
                print("UIImagePNGRepresentation fail")
            }
        }
    }
}
