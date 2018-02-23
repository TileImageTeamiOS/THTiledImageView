//
//  THTiledImageScrollViewTests.swift
//  THTiledImageViewTests
//
//  Created by 홍창남 on 2018. 2. 21..
//  Copyright © 2018년 홍창남. All rights reserved.
//

import XCTest
@testable import THTiledImageView

class THTiledImageScrollViewTests: XCTestCase {

    var scrollView: THTiledImageScrollView!

    var backgroundImage: UIImage?
    var dataSource: MyTileImageViewDataSource?

    override func setUp() {
        super.setUp()

        scrollView = THTiledImageScrollView()
        dataSource = MyTileImageViewDataSource(imageSize: CGSize(width: 5200, height: 4300), tileSize: [CGSize(width: 1024, height: 1024)])
        scrollView.set(dataSource: dataSource!)
    }

    func testRequestBackgroundImage() {
        let url = URL(string: "https://dl.dropbox.com/s/g1oomszqsnc5eue/smallBench.jpg")

        dataSource?.backgroundImageURL = url

        dataSource?.requestBackgroundImage { _ in
            self.backgroundImage = self.dataSource?.backgroundImage
        }

        let pred = NSPredicate(format: "backgroundImage != nil")
        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
        let result = XCTWaiter.wait(for: [exp], timeout: 5.0)

        let messages = ["The call to request background image has error", "The call to request background image into another error"]

        if result == XCTWaiter.Result.completed {
            XCTAssertNotNil(backgroundImage, messages[0])
        } else if result == XCTWaiter.Result.timedOut {
            XCTAssert(false, "Request Time out")
        } else {
            XCTAssert(false, messages[1])
        }
    }

    func testDataSourceContentSize() {

        let dataSource = MyTileImageViewDataSource(imageSize: CGSize(width: 5200, height: 4300), tileSize: [CGSize(width: 1024, height: 1024)])

        XCTAssert(dataSource.contentSize.width == 5200, "ScrollView ContentSize Setting Size Failed")
        XCTAssert(dataSource.contentSize.height == 4300, "ScrollView ContentSize Setting Size Failed")

    }

    func testInitZoomScale() {

         let dataSource = MyTileImageViewDataSource(imageSize: CGSize(width: 5200, height: 4300), tileSize: [CGSize(width: 1024, height: 1024)])
         scrollView.set(dataSource: dataSource)
         XCTAssert(scrollView.zoomScale == scrollView.minimumZoomScale, "ScrollView Zoom Scale is not same as minimum zoom scale")
         XCTAssert(scrollView.zoomScale != scrollView.maximumZoomScale, "ScrollView Zoom Scale is same as maximun zoom scale")
    }

    func testDoubleTapLargerZoom() {

        let dataSource = MyTileImageViewDataSource(imageSize: CGSize(width: 5200, height: 4300), tileSize: [CGSize(width: 1024, height: 1024)])
        scrollView.set(dataSource: dataSource)
        scrollView.zoomScale = 2
        scrollView.maximumZoomScale = 1
        scrollView.didDoubleTapped(scrollView.doubleTap)
        XCTAssert(scrollView.zoomScale != 1, "ScrollView Zoom Double Tap test fails")
    }

    func testDoubleTapSmallerZoom() {

        let dataSource = MyTileImageViewDataSource(imageSize: CGSize(width: 5200, height: 4300), tileSize: [CGSize(width: 1024, height: 1024)])
        scrollView.set(dataSource: dataSource)
        scrollView.zoomScale = 1
        scrollView.maximumZoomScale = 2

        let newScale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)
        scrollView.didDoubleTapped(scrollView.doubleTap)

//        XCTAssert(scrollView.zoomScale == newScale, "ScrollView Zoom Double Tap test fails")
    }

    func testScrollViewContentSize() {
        let dataSource = MyTileImageViewDataSource(imageSize: CGSize(width: 5200, height: 4300), tileSize: [CGSize(width: 1024, height: 1024)])

        print("contentSize", scrollView.contentSize)
        scrollView.set(dataSource: dataSource)
        print("contentSize", scrollView.contentSize)

    }
}
