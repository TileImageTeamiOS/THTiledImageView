//
//  TileImageView.swift
//  MyTileImageViewer
//
//  Created by 홍창남 on 2017. 12. 30..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

class TileImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(imageSize: CGSize) {
        self.init(frame: CGRect(origin: CGPoint.zero, size: imageSize))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
