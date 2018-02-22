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

    override func setUp() {
        super.setUp()

        scrollView = THTiledImageScrollView()

        let dataSource = MyTileImageViewDataSource(imageSize: CGSize(width: 5200, height: 4300), tileSize: [CGSize(width: 1024, height: 1024)])
        scrollView.set(dataSource: dataSource)
    }
    func testDataSourceContentSize() {

        let dataSource = MyTileImageViewDataSource(imageSize: CGSize(width: 5200, height: 4300), tileSize: [CGSize(width: 1024, height: 1024)])

        XCTAssert(dataSource.contentSize.width == 5200, "ScrollView ContentSize Setting Size Failed")
        XCTAssert(dataSource.contentSize.height == 4300, "ScrollView ContentSize Setting Size Failed")

    }

    func testInitZoomScale() {
         XCTAssert(scrollView.zoomScale == scrollView.minimumZoomScale, "ScrollView Zoom Scale is not same as minimum zoom scale")
         XCTAssert(scrollView.zoomScale != scrollView.maximumZoomScale, "ScrollView Zoom Scale is same as maximun zoom scale")
    }

    func testDoubleTapLargerZoom() {
        scrollView.zoomScale = 2
        scrollView.maximumZoomScale = 1
        scrollView.didDoubleTapped(scrollView.doubleTap)
        XCTAssert(scrollView.zoomScale != 1, "ScrollView Zoom Double Tap test fails")
    }

    func testDoubleTapSmallerZoom() {
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

//        XCTAssert(scrollView.bounds.size.width == 5200, "ScrollView ContentSize Setting Size Failed")
//        XCTAssert(scrollView.contentSize.height == 4300, "ScrollView ContentSize Setting Size Failed")



//        scrollView.zoomScale = 3
//        scrollView.maximumZoomScale = 2
//
//        let boundsSize = bounds.size
//        let imageSize = dataSource.contentSize
//
//        let xScale = boundsSize.width / imageSize.width
//        let yScale = boundsSize.height / imageSize.height
//
//        let minScale = min(xScale, yScale)
//
//        minimumZoomScale = minScale
//
//        let xScale = boundsSize.width / imageSize.width
//        let yScale = boundsSize.height / imageSize.height
//

    }
}
