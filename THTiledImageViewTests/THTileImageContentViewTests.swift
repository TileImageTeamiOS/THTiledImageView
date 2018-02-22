//
//  THTileImageContentView.swift
//  THTiledImageViewTests
//
//  Created by 홍창남 on 2018. 2. 22..
//  Copyright © 2018년 홍창남. All rights reserved.
//

import XCTest
@testable import THTiledImageView

class THTileImageContentViewTests: XCTestCase {

    var scrollView: THTiledImageScrollView!
    var contentView: THTiledImageContentView?
    var dataSource: MyTileImageViewDataSource?

    var contentBackground: UIImage?

    override func setUp() {
        super.setUp()
        scrollView = THTiledImageScrollView()

    }

//    func testContentViewBackgroundImage() {
//        dataSource = MyTileImageViewDataSource(imageSize: CGSize(width: 5200, height: 4300), tileSize: [CGSize(width: 1024, height: 1024)])
//        dataSource?.backgroundImageURL = URL(string: "https://dl.dropbox.com/s/g1oomszqsnc5eue/smallBench.jpg")
//
//        let tileImageView = THTiledImageView(dataSource: dataSource!)
//        contentView = THTiledImageContentView(tileImageView: tileImageView, dataSource: dataSource!)
//
//        let pred = NSPredicate(format: "dataSource.backgroundImage != nil")
//        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
//        let result = XCTWaiter.wait(for: [exp], timeout: 5.0)
//
//        let messages = ["The call to request background image has error", "The call to request background image into another error"]
//
//        if result == XCTWaiter.Result.completed {
//            XCTAssertNotNil(dataSource?.backgroundImage, messages[0])
//        } else if result == XCTWaiter.Result.timedOut {
//            XCTAssert(false, "Request Time out")
//        } else {
//            XCTAssert(false, messages[1])
//        }
//    }
}

//init(tileImageView: THTiledImageView, dataSource: THTiledImageViewDataSource) {
//    self.tileImageView = tileImageView
//    self.backgroundImageView = UIImageView(frame: tileImageView.bounds)
//    super.init(frame: tileImageView.frame)
//
//    backgroundImageView.contentMode = .scaleAspectFit
//
//    if let backgroundImage = dataSource.backgroundImage {
//        backgroundImageView.image = backgroundImage
//    } else {
//        dataSource.requestBackgroundImage { image in
//            DispatchQueue.main.async {
//                if let image = image {
//                    self.backgroundImageView.image = image
//                    self.backgroundImageView.setNeedsDisplay()
//                }
//            }
//        }
//    }
//    self.addSubview(backgroundImageView)
//    self.addSubview(tileImageView)
//}

