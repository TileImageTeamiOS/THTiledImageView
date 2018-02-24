//
//  THTiledImageScrollView.swift
//  THTiledImageScrollView
//
//  Created by 홍창남 on 2017. 12. 28..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

@objc protocol DoubleTappable {
    var doubleTap: UITapGestureRecognizer! { get set }
    @objc func didDoubleTapped(_ gestureRecognizer: UIGestureRecognizer)
}

open class THTiledImageScrollView: UIScrollView {

    weak var tileImageScrollViewDelegate: THTiledImageScrollViewDelegate?

    private var contentView: THTiledImageContentView?
    weak var dataSource: THTiledImageViewDataSource?
    private var currentBounds: CGSize = .zero
    public internal(set) var doubleTap: UITapGestureRecognizer!

    public func set(dataSource: THTiledImageViewDataSource) {
        delegate = self
        self.tileImageScrollViewDelegate = dataSource.delegate

        // set doubleTapp
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(THTiledImageScrollView.didDoubleTapped(_:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)

        self.dataSource = dataSource

        // set subView
        let tileImageView = THTiledImageView(dataSource: dataSource)
        tileImageView.dataSource = dataSource

        contentView = THTiledImageContentView(tileImageView: tileImageView, dataSource: dataSource)
        if let contentView = contentView {
            self.addSubview(contentView)
        }

        // set contentSize & frame
        self.contentSize = dataSource.contentSize

        if let scrollViewSize = dataSource.scrollViewSize {
            currentBounds = scrollViewSize
            frame.size = currentBounds
        }

        setMaxMinZoomScalesForCurrentBounds()
        setZoomScale(minimumZoomScale, animated: false)

        setContentInset()
    }

    // MARK: Set content TopX and TopY for contentView
    private func setContentInset() {
        let marginX = (bounds.width - contentSize.width) / 2
        let marginY = (bounds.height - contentSize.height) / 2
        let topX = max(marginX, 0)
        let topY = max(marginY, 0)
        self.contentInset = UIEdgeInsets(top: topY, left: topX, bottom: topY, right: topX)
    }

    // Scale contentSize
    private func setMaxMinZoomScalesForCurrentBounds() {
        guard let dataSource = dataSource else {
            return
        }

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
extension THTiledImageScrollView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tileImageScrollViewDelegate?.didScroll(scrollView: self)
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        tileImageScrollViewDelegate?.didZoom(scrollView: self)
    }

}

// MARK: DoubleTappable
extension THTiledImageScrollView: DoubleTappable {

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
