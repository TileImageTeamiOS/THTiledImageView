//
//  THTiledImageContentView.swift
//  THTiledImageContentView
//
//  Created by 홍창남 on 2017. 12. 30..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit
import Kingfisher

class THTiledImageContentView: UIView {

    let tileImageView: THTiledImageView
    let backgroundImageView: UIImageView

    init(tileImageView: THTiledImageView, dataSource: THTiledImageViewDataSource) {
        self.tileImageView = tileImageView
        self.backgroundImageView = UIImageView(frame: tileImageView.bounds)
        super.init(frame: tileImageView.frame)

        tileImageView.backgroundColor = UIColor.black.withAlphaComponent(0)
        backgroundImageView.contentMode = .scaleAspectFit

        if let backgroundImage = dataSource.backgroundImage {
            backgroundImageView.image = backgroundImage
        } else {
            dataSource.requestBackgroundImage { image in
                DispatchQueue.main.async {
                    if let image = image {
                        self.backgroundImageView.image = image
                        self.backgroundImageView.setNeedsDisplay()
                    }
                }
            }
        }
        self.addSubview(backgroundImageView)
        self.addSubview(tileImageView)
   }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
