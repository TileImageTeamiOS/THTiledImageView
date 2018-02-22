//
//  ImageGenergateHelperTests.swift
//  THTiledImageViewTests
//
//  Created by 홍창남 on 2018. 2. 22..
//  Copyright © 2018년 홍창남. All rights reserved.
//

import XCTest
@testable import THTiledImageView

class ImageGenergateHelperTests: XCTestCase {

    var imageExist: Bool = false

    let randomString = NSUUID().uuidString

    override func tearDown() {
        // remove created directory for testing
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String

        let dirPath = "\(cachesPath)/\(randomString)"
        let benchPath = "\(cachesPath)/bench"

        do {
            try FileManager.default.removeItem(atPath: dirPath)
            try FileManager.default.removeItem(atPath: benchPath)
        } catch let err {
            print(err)
        }

        super.tearDown()
    }

    func testDirectoryExists() {
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String

        let dirPath = "\(cachesPath)/\(randomString)"

        FileManager.createContainerDirectory(path: dirPath)

        var result = false
        if let contents = try? FileManager.default.contentsOfDirectory(atPath: "\(cachesPath)") {
            contents.forEach { dir in
                if dir == "bench" {
                    result = true
                }
            }
        }
        XCTAssert(result, "directory is not created.")
    }

    func testCuttingImages() {
        let tiles: [CGSize] = [CGSize(width: 1024, height: 1024), CGSize(width: 512, height: 512)]

        UIImage.saveTileOf(size: tiles, name: "bench", withExtension: "jpg") { _ in
            let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String

            let path = "\(cachesPath)/bench/1024/" + "bench_1024_1_0_0.jpg"
            if FileManager.default.fileExists(atPath: path) {
                self.imageExist = true
            }
        }

        let pred = NSPredicate(format: "imageExist == true")
        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
        let result = XCTWaiter.wait(for: [exp], timeout: 10.0)

        if result == XCTWaiter.Result.completed {
            XCTAssert(imageExist, "The call to get the url into another error")
        } else {
            XCTAssert(false, "The call to cut image into another error")
        }

    }
}
