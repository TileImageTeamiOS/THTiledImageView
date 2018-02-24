//
//  THTiledImageViewTests.swift
//  THTiledImageViewTests
//
//  Created by 홍창남 on 2018. 2. 12..
//  Copyright © 2018년 홍창남. All rights reserved.
//

import XCTest
@testable import THTiledImageView

class THTiledImageViewTests: XCTestCase {

    var scrollView: THTiledImageScrollView!
    var dataSource: MyTileImageViewDataSource?
    var contentView: THTiledImageContentView?

    override func setUp() {
        super.setUp()
        scrollView = THTiledImageScrollView()
        dataSource = MyTileImageViewDataSource(imageSize: CGSize(width: 5200, height: 4300), tileSize: [CGSize(width: 1024, height: 1024)])

    }

    func testTiledImageDraw() {
        dataSource?.maxTileLevel = 3
        dataSource?.minTileLevel = 1
        scrollView.set(dataSource: dataSource!)

        guard let dataSource = dataSource else { return }

        let tileImageView = THTiledImageView(dataSource: dataSource)
        tileImageView.dataSource = dataSource

        contentView = THTiledImageContentView(tileImageView: tileImageView, dataSource: dataSource)

        let rect = CGRect(x: 0, y: 0, width: 256, height: 256)
        tileImageView.draw(rect)
    }

    func testTileImageLoadRemote() {
        dataSource?.maxTileLevel = 3
        dataSource?.minTileLevel = 1
        dataSource?.accessFromServer = true
        dataSource?.tileImageBaseURL = URL(string: "http://127.0.0.1:5000/bench")!

        scrollView.set(dataSource: dataSource!)

        guard let dataSource = dataSource else { return }

        let tileImageView = THTiledImageView(dataSource: dataSource)
        tileImageView.dataSource = dataSource

        contentView = THTiledImageContentView(tileImageView: tileImageView, dataSource: dataSource)

        let rect = CGRect(x: 0, y: 0, width: 256, height: 256)
        tileImageView.draw(rect)
    }

    func testTiledLayer() {
        // default value = 0.0
        let defaultValue = TiledLayer.tileFadeDuration
        TiledLayer.setFadeDuration(1.0)
        XCTAssert(TiledLayer.tileFadeDuration != defaultValue, "Fade Duration has not been changed")
    }
}
