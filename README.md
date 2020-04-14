#### Demo

- [Demo Video](https://youtu.be/6RV-cuQPIvQ)

# NFImageView

- [x] Realtime loading progress.
- [x] Loading option with progress or spinner.
- [x] Loading option with blur using thumbnail and a larger image.
- [x] Prevent loading wrong image when on a table or collection view.
- [x] Uses CoreGraphics to draw image in context.
- [x] Supports 'Content Fill Location' : '.Top, .Left, .Right, .Bottom' 

## Requirements

- iOS 13.0+
- Xcode 11+
- Swift 5.1+

## Installation

#### CocoaPods
NFImageView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
platform :ios, '13.0'
use_frameworks! # remove this if this will be used in ObjC code.

pod "NFImageView"
```

#### Carthage
Create a `Cartfile` that lists the framework and run `carthage update`. Follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios) to add `$(SRCROOT)/Carthage/Build/iOS/NFImageView.framework` to an iOS project.

```
github "nferocious76/NFImageView"
```

#### Manually
1. Download and drop ```/Pod/Classes``` folder in your project.  
2. Congratulations!

## Image View Functions
```Available functions```

```Swift

imageView.setImage(fromURL: <#T##URL#>)
imageView.setImage(fromURL: <#T##URL#>, completion: <#T##NFImageViewRequestCompletion?##NFImageViewRequestCompletion?##(NFImageViewRequestCode, NSError?) -> Void#>)

imageView.setImage(fromURLString: <#T##String#>)
imageView.setImage(fromURLString: <#T##String#>, completion: <#T##NFImageViewRequestCompletion?##NFImageViewRequestCompletion?##(NFImageViewRequestCode, NSError?) -> Void#>)

imageView.setThumbImageAndLargeImage(fromURL: <#T##URL#>, largeURL: <#T##URL#>)
imageView.setThumbImageAndLargeImage(fromURL: <#T##URL#>, largeURL: <#T##URL#>, completion: <#T##NFImageViewRequestCompletion?##NFImageViewRequestCompletion?##(NFImageViewRequestCode, NSError?) -> Void#>)

imageView.setThumbImageAndLargeImage(fromURLString: <#T##String#>, largeURLString: <#T##String#>)
imageView.setThumbImageAndLargeImage(fromURLString: <#T##String#>, largeURLString: <#T##String#>, completion: <#T##NFImageViewRequestCompletion?##NFImageViewRequestCompletion?##(NFImageViewRequestCode, NSError?) -> Void#>)

```

## Usage example

```Swift

// link of images
let thumbnail = "https://scontent.fmnl4-4.fna.fbcdn.net/v/t1.0-9/13529069_10202382982213334_6754953260473113193_n.jpg?oh=28c0f3e751a9177e5ca0afaf23be919e&oe=57F9EEF9"
let largeImage = "https://scontent.fmnl4-4.fna.fbcdn.net/t31.0-8/13584845_10202382982333337_2990050100601729771_o.jpg"

// NFImageView is like a regular UIImageView, you can either subclass a UIImageView in the IB, just set the module to `NFUIKitUtilities` for the IB to read the class.
// create an imageview
let imageview = NFImageView(frame: CGRectMake(0, 0, 100, 100))

// `loadingEnabled` flag is use to force disable any loading that should occur. This will make it load like normal. default to `true`
// imageView.loadingEnabled = false // set this to disable loading.

// set loading type
imageview.loadingType = .Spinner

// loading an image without blur effect.
imageView.setImageFromURLString(largeImage)

// loading an image with blur effect using thumbnail and large image.
imageview.setThumbImageAndLargeImageFromURLString(thumbURLString: thumbnail, largeURLString: largeImage)

// Set image aspect
imageView.contentViewMode = .Fill || .AspectFit || .AspectFill || .OriginalSize

// Set image fill location
imageView.contentViewFill = .Center || .Top || .Left || .Right || .Bottom

```

## Contribute
We would love for you to contribute to `NFImageView`. See the [LICENSE](https://github.com/nferocious76/NFImageView/blob/master/LICENSE) file for more info.

## Author

Neil Francis Ramirez Hipona, nferocious76@gmail.com

## License

NFImageView is available under the MIT license. See the [LICENSE](https://github.com/nferocious76/NFImageView/blob/master/LICENSE) file for more info.
