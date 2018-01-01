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

        let imageSize = CGSize(width: 5214, height: 7300)
        let tileSize = CGSize(width: 256, height: 256)

        let imageURL = Bundle.main.url(forResource: "bench", withExtension: "jpg")!
//        let imageURL = URL(string: "https://dl.dropbox.com/s/t1xwici6yuxplo0/bench.jpg")!

        setupExample(imageSize: imageSize, tileSize: tileSize, imageURL: imageURL)
    }

    func setupExample(imageSize: CGSize, tileSize: CGSize, imageURL: URL) {

        dataSource = MyTileImageViewDataSource(imageSize: imageSize, tileSize: tileSize, imageURL: imageURL)

        tileImageScrollView.set(dataSource: dataSource!)

        dataSource?.requestBackgroundImage { (image) in

        }
    }
}
