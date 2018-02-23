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

        let tiles: [CGSize] = [CGSize(width: 1024, height: 1024), CGSize(width: 512, height: 512), CGSize(width: 256, height: 256)]

//        UIImage.saveTileOf(size: tiles, name: "bench", withExtension: "jpg") { _ in
//
//        }

        let imageSize = CGSize(width: 5214, height: 7300)
        let thumbnailImageURL = Bundle.main.url(forResource: "smallBench", withExtension: "jpg")!

        let tileImageBaseURL = URL(string: "http://127.0.0.1:5000/bench")!

        setupExample(tileImageBaseURL: tileImageBaseURL, imageSize: imageSize, tileSize: tiles, thumbnail: thumbnailImageURL)

        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String
        print(cachesPath)
    }

    func setupExample(tileImageBaseURL: URL, imageSize: CGSize, tileSize: [CGSize], thumbnail: URL) {

        dataSource = MyTileImageViewDataSource(tileImageBaseURL: tileImageBaseURL, imageSize: imageSize, tileSize: tileSize)

        guard let dataSource = dataSource else { return }

        dataSource.thumbnailImageName = "bench"

        // 줌을 가장 많이 확대한 수준
        dataSource.maxTileLevel = 3

        // 줌이 가장 확대가 안 된 수준
        dataSource.minTileLevel = 1

        dataSource.maxZoomLevel = 8

        dataSource.imageExtension = "jpg"

        // Local Image For Background
        dataSource.setBackgroundImage(url: thumbnail)

        dataSource.scrollViewSize = setScrollViewSize()
        // Remote Image For Background
//        dataSource.backgroundImageURL = URL(string: "https://dl.dropbox.com/s/g1oomszqsnc5eue/smallBench.jpg")!
//        dataSource.requestBackgroundImage { _ in }

        tileImageScrollView.set(dataSource: dataSource)
    }

    func setScrollViewSize() -> CGSize {
        var height = UIApplication.shared.statusBarFrame.height
        if let navCon = self.navigationController {
            height += navCon.navigationBar.frame.size.height
        }

        var scrollViewSize = CGSize(width: self.view.frame.size.width,
                                    height: self.view.frame.size.height - height)

        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.delegate?.window {
                if let bottomPadding = window?.safeAreaInsets.bottom {
                    scrollViewSize.height -= bottomPadding
                }
            }
        }
        
        print(scrollViewSize)
        return scrollViewSize
    }
}
