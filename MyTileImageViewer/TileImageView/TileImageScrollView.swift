//
//  TileImageScrollView.swift
//  MyTileImageViewer
//
//  Created by 홍창남 on 2017. 12. 28..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

protocol TileImageScrollViewDelegate: class {
    func scrollViewDidZoom(scrollView: TileImageScrollView)
}

public class TileImageScrollView: UIScrollView {

    private var contentView: TileImageContentView?
    weak var dataSource: TileImageViewDataSource?
    private var currentBounds = CGSize.zero

    public override var contentSize: CGSize {
        didSet {
            contentSizeOrBoundsDidChange()
        }
    }
    public override var bounds: CGRect {
        didSet {
            contentSizeOrBoundsDidChange()
        }
    }

    public func set(dataSource: TileImageViewDataSource) {
        delegate = self

        self.dataSource = dataSource

        let tileImageView = TileImageView(imageSize: dataSource.imageSize)
        tileImageView.dataSource = dataSource

        contentView = TileImageContentView(tileImageView: tileImageView, dataSource: dataSource)
        if let contentView = contentView {
            self.addSubview(contentView)
        }

        currentBounds = bounds.size
        self.contentSize = dataSource.contentSize

        setMaxMinZoomScalesForCurrentBounds()
        setZoomScale(minimumZoomScale, animated: false)
    }

    // Scale contentSize
    private func setMaxMinZoomScalesForCurrentBounds() {
        guard let dataSource = dataSource else {
            return
        }
        setNeedsLayout()
        layoutIfNeeded()

        let boundsSize = bounds.size
        let imageSize = dataSource.contentSize

        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height

        let minScale = min(xScale, yScale)

        minimumZoomScale = minScale
        if let maxZoom = dataSource.maxZoomLevel {
            maximumZoomScale = maxZoom
        }

        if minimumZoomScale > zoomScale {
            setZoomScale(minimumZoomScale, animated: false)
        }
    }
}

extension TileImageScrollView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {

    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }

    // Set content TopX and TopY for contentView
    private func contentSizeOrBoundsDidChange() {
        if currentBounds != bounds.size {
            currentBounds = bounds.size
            setMaxMinZoomScalesForCurrentBounds()
        }
        let topX = max((bounds.width - contentSize.width)/2, 0)
        let topY = max((bounds.height - contentSize.height)/2, 0)
        contentView?.frame.origin = CGPoint(x: topX, y: topY)
    }
}
