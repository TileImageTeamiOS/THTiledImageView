//
//  TileImageScrollView.swift
//  MyTileImageViewer
//
//  Created by 홍창남 on 2017. 12. 28..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

@objc protocol DoubleTappable {
    var doubleTap: UITapGestureRecognizer! { get set }
    @objc func didDoubleTapped(_ gestureRecognizer: UIGestureRecognizer)
}

open class TileImageScrollView: UIScrollView {

    var tileImageScrollViewDelegate: TileImageScrollViewDelegate?

    private var contentView: TileImageContentView?
    weak var dataSource: TileImageViewDataSource?
    private var currentBounds = CGSize.zero
    public internal(set) var doubleTap: UITapGestureRecognizer!

    open override var contentSize: CGSize {
        didSet {
            contentSizeOrBoundsDidChange()
        }
    }

    open override var bounds: CGRect {
        didSet {
            contentSizeOrBoundsDidChange()
        }
    }

    public func set(dataSource: TileImageViewDataSource) {
        delegate = self

        doubleTap = UITapGestureRecognizer(target: self, action: #selector(TileImageScrollView.didDoubleTapped(_:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)

        self.dataSource = dataSource

        self.tileImageScrollViewDelegate = dataSource.delegate

        let tileImageView = TileImageView(dataSource: dataSource)
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

// MARK: UIScrollViewDelegate
extension TileImageScrollView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
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

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tileImageScrollViewDelegate?.didScroll(scrollView: self)
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        tileImageScrollViewDelegate?.didZoom(scrollView: self)
    }

}

// MARK: DoubleTappable
extension TileImageScrollView: DoubleTappable {

    @objc func didDoubleTapped(_ gestureRecognizer: UIGestureRecognizer) {
        if zoomScale >= maximumZoomScale {
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            let tapCenter = gestureRecognizer.location(in: contentView)
            let newScale = min(zoomScale * 2, maximumZoomScale)
            let maxZoomRect = rect(around: tapCenter, atZoomScale: newScale)
            zoom(to: maxZoomRect, animated: true)
        }
    }

    private func rect(around point: CGPoint, atZoomScale zoomScale: CGFloat) -> CGRect {
        let boundsSize = bounds.size
        let scaledBoundsSize = CGSize(width: boundsSize.width / zoomScale, height: boundsSize.height / zoomScale)
        let point = CGRect(x: point.x - scaledBoundsSize.width / 2, y: point.y - scaledBoundsSize.height / 2,
                           width: scaledBoundsSize.width, height: scaledBoundsSize.height)
        return point
    }
}
