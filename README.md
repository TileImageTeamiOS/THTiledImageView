#  THTiledImageView

![Version](https://img.shields.io/badge/pod-v0.2.1-blue.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://github.com/younatics/YNDropDownMenu/blob/master/LICENSE)
![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)
![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-%23FB613C.svg)](https://developer.apple.com/swift/)

## Feature

- [x] 🖼 `THTiledImageView` fully support `UIScrollView`. You can subclass it and use it.
- [x] 🔪 Support Image Cutting Extension Method to generate tiled images.
- [x] 🔍 You can set different tiled images based on user's zoom scale.

## Demo

![THTileImageView](images/THTileImageView.gif)

## Installation

### CocoaPods

To integrate `THTiledImageView` into your Xcode project using CocoaPods, specify it in your Podfile:

```
pod "THTiledImageView"
```

## Requirements

`THTiledImageView` is written in Swift 4, and compatible with iOS 9.0+

## How to use

### SubClassing

1. `THTiledImageScrollView` is subclass of UIScrollVIew. Create `THTiledImageScrollView` from Storyboard or programmatically.


2. Create dataSource class that is subclass of `THTiledImageViewDataSource`.

```Swift
var dataSource: THTiledImageViewDataSource?
```


3. Here is `THTiledImageViewDataSource` options that you can use.

```Swift
func setupExample(imageSize: CGSize, tileSize: [CGSize], imageURL: URL) {

    dataSource = MyTileImageViewDataSource(imageSize: imageSize, tileSize: tileSize, imageURL: imageURL)
    dataSource?.thumbnailImageName = "bench"

    // maximun tile level
    // When you zoom in this level, you can see level 5 tiles.
    dataSource?.maxTileLevel = 5

    // minimum tile level
    dataSource?.minTileLevel = 1

    // scrollView allowable maximum zoom level
    dataSource?.maxZoomLevel = 8

    dataSource?.imageExtension = "jpg"
    tileImageScrollView.set(dataSource: dataSource!)

    dataSource?.requestBackgroundImage { _ in
        // do something after image shows.
    }
}
```

### Zoom and Tile Level

`THTiledImageView`'s zoom level and tile level can be set separately.

#### Zoom Level

UIScrollView's Zoom level. Default `minimum zoom level` is scale aspect fit size of scrollView. `maximum zoom level` is allowable zoom in level.

#### Tile Level

Tiled images can be shown at specific zoom level based on tile level. For example, if you set `(minTileLevel, maxTileLevel) = (1, 5)`, You can set 5 different images by tile level.

Tile level 1 can be used wide range of image.

<img src="images/example_level_1.png" style="max-width: 50%">

Tile level 5(or more than 1) can be used narrow range of image.

<img src="images/example_level_5.png" style="max-width: 50%">


### Cutting Image

> ❗️ So far cutting and rendering images cannot be done simultaneously. You should cut image first, and relaunch the app.

We offer you image cutting function(`UIImage.saveTileOf(size:name:withExtension:)`. Specify the size of tiles by levels.

```Swift
// size and level will be 512-1, 256-2, 128-3(size-level).
let tiles: [CGSize] = [CGSize(width: 512, height: 512),
                       CGSize(width: 256, height: 256), CGSize(width: 128, height: 128)]

// static function
UIImage.saveTileOf(size: tiles, name: "bench", withExtension: "jpg")
```

#### Tiled Images path

Tiled images will be saved on your cache directory. Path of the cache directory:

```Swift
let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String
```

If imagefile saved successfully, you can see images from cache directory. Here is the rule of directory path and image file name rules.

```
Path Rules ./imageName/imageSize/{imageName_imageSize_level_x_y}.jpg
Example    ./bench/256/bench_256_1_0_0.jpg
```

> ❗️ If you create images on your own, you need to obey the path rules.

### THTiledImageScrollViewDelegate

You can use `UIScrollViewDelegate` methods from `THTiledImageScrollViewDelegate`.

```Swift
public protocol THTiledImageScrollViewDelegate: class {
    func didScroll(scrollView: THTiledImageScrollView)
    func didZoom(scrollView: THTiledImageScrollView)
}
```

See our example for more details.

## License

`THTiledImageView` is released under the MIT license. [See LICENSE](https://github.com/TileImageTeamiOS/THTiledImageView/blob/master/LICENSE) for details.
