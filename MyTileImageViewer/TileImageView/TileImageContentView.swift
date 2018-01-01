//
//  TileImageContentView.swift
//  MyTileImageViewer
//
//  Created by 홍창남 on 2017. 12. 30..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

class TileImageContentView: UIView {

    let tileImageView: TileImageView
    let backgroundImageView: UIImageView

    var dataSource: TileImageViewDataSource?

    init(tileImageView: TileImageView, dataSource: TileImageViewDataSource) {
        self.tileImageView = tileImageView
        self.backgroundImageView = UIImageView(frame: tileImageView.bounds)
        super.init(frame: tileImageView.frame)

        backgroundImageView.contentMode = .scaleAspectFit

        dataSource.requestBackgroundImage { [weak self] image in
            DispatchQueue.main.async {
                self?.backgroundImageView.image = image
            }
        }

        self.addSubview(backgroundImageView)
        self.addSubview(tileImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
