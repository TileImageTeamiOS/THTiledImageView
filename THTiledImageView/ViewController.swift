//
//  ViewController.swift
//  THTiledImageView
//
//  Created by 홍창남 on 2017. 12. 28..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tileImageScrollView: THTiledImageScrollView!
    var dataSource: THTiledImageViewDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        let tiles: [CGSize] = [CGSize(width: 2048, height: 2048), CGSize(width: 1024, height: 1024),
                               CGSize(width: 512, height: 512), CGSize(width: 256, height: 256),
                               CGSize(width: 128, height: 128)]

        UIImage.saveTileOf(size: tiles, name: "bench", withExtension: "jpg") { _ in

        }

        let imageSize = CGSize(width: 5214, height: 7300)
        let thumbnailImageURL = Bundle.main.url(forResource: "smallBench", withExtension: "jpg")!

        setupExample(imageSize: imageSize, tileSize: tiles, imageURL: thumbnailImageURL)

    }

    func setupExample(imageSize: CGSize, tileSize: [CGSize], imageURL: URL) {

        dataSource = MyTileImageViewDataSource(imageSize: imageSize, tileSize: tileSize, imageURL: imageURL)
        dataSource?.thumbnailImageName = "bench"

        // 줌을 가장 많이 확대한 수준
        dataSource?.maxTileLevel = 5

        // 줌이 가장 확대가 안 된 수준
        dataSource?.minTileLevel = 1

        dataSource?.maxZoomLevel = 8

        dataSource?.imageExtension = "jpg"
        tileImageScrollView.set(dataSource: dataSource!)

        dataSource?.requestBackgroundImage { _ in

        }
    }

    func dummy() {
//        UIImage.saveTileOfSize(tiles, name: "windingRoad")
//        let imageSize = CGSize(width: 5120, height: 3200)
//        UIImage.saveTileOfSize(tileSize, name: "windingRoad")
//        let imageSize = CGSize(width: 5120, height: 3200)
//        let imageURL = Bundle.main.url(forResource: "bench", withExtension: "jpg")!
//        let imageURL = Bundle.main.url(forResource: "windingRoad", withExtension: "jpg")!
//        let imageURL = URL(string: "https://dl.dropbox.com/s/t1xwici6yuxplo0/bench.jpg")!
    }
}
