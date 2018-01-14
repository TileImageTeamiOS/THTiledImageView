//
//  TileImageScrollView.swift
//  THTiledImageView
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

    private var contentView: TileImageContentView?
    weak var dataSource: THTiledImageViewDataSource?
    private var currentBounds: CGSize = .zero
    public internal(set) var doubleTap: UITapGestureRecognizer!

    public func set(dataSource: THTiledImageViewDataSource) {
        delegate = self

        doubleTap = UITapGestureRecognizer(target: self, action: #selector(THTiledImageScrollView.didDoubleTapped(_:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)

        self.dataSource = dataSource

        self.tileImageScrollViewDelegate = dataSource.delegate

        let tileImageView = THTiledImageView(dataSource: dataSource)
        tileImageView.dataSource = dataSource

        contentView = TileImageContentView(tileImageView: tileImageView, dataSource: dataSource)
        if let contentView = contentView {
            self.addSubview(contentView)
        }

        currentBounds = bounds.size
        self.contentSize = dataSource.contentSize

        setMaxMinZoomScalesForCurrentBounds()
        setZoomScale(minimumZoomScale, animated: false)

        setContentInset()
    }

    // MARK: Set content TopX and TopY for contentView
    private func setContentInset() {
        let horizontalSpace = max(-(contentSize.width - bounds.width)/2, 0)
        let verticalSpace = max(-(contentSize.height - bounds.height)/2, 0)

        let statusBarHeight = UIApplication.shared.statusBarFrame.height

        self.contentInset = UIEdgeInsets(top: verticalSpace - (statusBarHeight / 2), left: horizontalSpace,
                                         bottom: verticalSpace - (statusBarHeight / 2), right: horizontalSpace)

        if UIDevice.current.isiPhoneX {
            contentInset.top -= 17
            contentInset.bottom -= 17
        }

        if bounds.origin.y != 0 {
            bounds.origin.y = 0
        }

        if bounds.origin.x != 0 {
            bounds.origin.x = 0
        }

        if let viewController = self.superview?.getParentViewController() {
            if let navHeight = viewController.navigationController?.navigationBar.frame.height {
                contentInset.top -= navHeight / 2
                contentInset.bottom -= navHeight / 2
            }
        }
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

// MARK: For Positioning ContentView to Center in ScrollView
extension UIResponder {
    func getParentViewController() -> UIViewController? {
        if self.next is UIViewController {
            return self.next as? UIViewController
        } else {
            if let n = self.next {
                return n.getParentViewController()
            } else {
                return nil
            }
        }
    }
}

// MARK: For iPhoneX Detection
extension UIDevice {
    var isiPhoneX: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone &&
            (UIScreen.main.bounds.size.height == 812 &&
              UIScreen.main.bounds.size.width == 375) {
            return true
        }
        return false
    }
}
