//
//  ImageManagerTest.swift
//  THTiledImageViewTests
//
//  Created by 홍창남 on 2018. 2. 22..
//  Copyright © 2018년 홍창남. All rights reserved.
//

import XCTest
@testable import THTiledImageView
import Kingfisher

class ImageManagerTest: XCTestCase {

    var downloadImage1: UIImage?
    var downloadImage2: UIImage?

    var cachedImage: UIImage?

    override func tearDown() {
        ImageCache.default.removeImage(forKey: "https://dl.dropbox.com/s/g1oomszqsnc5eue/smallBench.jpg")
        super.tearDown()
    }
    func testDownloadMangerSuccess() {
        let url = URL(string: "https://dl.dropbox.com/s/g1oomszqsnc5eue/smallBench.jpg")!

        THImageDownloadManager.default.downloadEachTiles(path: url) { image, _, error in
            if error == nil {
                self.downloadImage1 = image
            }
        }

        let pred = NSPredicate(format: "downloadImage1 != nil")
        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
        let result = XCTWaiter.wait(for: [exp], timeout: 5.0)

        let messages = ["The call to download image has error", "The call to download image into another error"]

        if result == XCTWaiter.Result.completed {
            XCTAssertNotNil(downloadImage1, messages[0])
        } else if result == XCTWaiter.Result.timedOut {
            XCTAssert(false, "Request Time out")
        } else {
            XCTAssert(false, messages[1])
        }
    }

    func testDownloadMangerError() {
        let url = URL(string: "https://dl.dropboxusercontent.com/s/g1oo")!

        THImageDownloadManager.default.downloadEachTiles(path: url) { _, _, error in
            if error != nil {
                self.downloadImage2 = nil
            } else {
                self.downloadImage2 = UIImage()
            }
        }

        let pred = NSPredicate(format: "downloadImage2 != nil")
        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
        let result = XCTWaiter.wait(for: [exp], timeout: 5.0)

        let messages = ["The call to download image has error", "The call to download image into another error"]

        if result == XCTWaiter.Result.completed || result == XCTWaiter.Result.timedOut {
            XCTAssertNil(downloadImage2, messages[0])
        } else {
            XCTAssert(false, messages[1])
        }
    }

    func testCacheManger() {
        let url = URL(string: "https://dl.dropbox.com/s/g1oomszqsnc5eue/smallBench.jpg")!

        THImageDownloadManager.default.downloadEachTiles(path: url) { image, _, _ in

            guard let image = image else { return }

            THImageCacheManager.default.cacheTiles(image: image, imageIdentifier: url.absoluteString) {
                if let image = THImageCacheManager.default.retrieveTiles(key: url.absoluteString) {
                    self.cachedImage = image
                }
            }
        }

        let pred = NSPredicate(format: "cachedImage != nil")
        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
        let result = XCTWaiter.wait(for: [exp], timeout: 7.0)

        let messages = ["The call to cache image has error", "The call to cache image into another error"]

        if result == XCTWaiter.Result.completed {
            XCTAssertNotNil(cachedImage, messages[0])
        } else if result == XCTWaiter.Result.timedOut {
            XCTAssert(false, "Request Time out")
        } else {
            XCTAssert(false, messages[1])
        }
    }
}
