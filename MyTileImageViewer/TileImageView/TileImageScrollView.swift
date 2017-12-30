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

    public func set(dataSource: TileImageViewDataSource) {
        self.dataSource = dataSource

        let tileImageView = TileImageView(imageSize: dataSource.imageSize)

        contentView = TileImageContentView(tileImageView: tileImageView, dataSource: dataSource)
        if let contentView = contentView {
            self.addSubview(contentView)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.contentSize = (contentView?.frame.size)!
    }
}

extension TileImageScrollView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
}
