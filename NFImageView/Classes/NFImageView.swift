//
//  NFImageView.swift
//  Pods
//
//  Created by Neil Francis Hipona on 23/07/2016.
//  Copyright (c) 2016 Neil Francis Ramirez Hipona. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

public class NFImageView: UIView {
    
    // MARK: - Private property
    
    internal lazy var loadingIndicator: UIActivityIndicatorView = {
        return self.prepareLoadingIndicator()
    }()
    
    internal lazy var loadingProgressView: UIProgressView = {
        return self.prepareLoadingProgressView()
    }()
    
    internal lazy var blurEffect: UIVisualEffectView = {
        return self.prepareVisualBlurEffectView()
    }()
    
    internal var requestReceipt: RequestReceipt?
    
    // MARK: - Public property
    
    public var contentViewMode: ViewContentMode = .AspectFill
    public var contentViewFill: ViewContentFill = .Center
    public var loadingType: NFImageViewLoadingType = .Default
    
    public var loadingEnabled: Bool = true
    
    public var highlighted: Bool = false {
        didSet { setNeedsDisplay() }
    }
    
    // default is nil
    public var image: UIImage? {
        didSet { setNeedsDisplay() }
    }
    
    // default is nil
    public var highlightedImage: UIImage? {
        didSet { setNeedsDisplay() }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    // Convenience
    
    public convenience init(image img: UIImage?, highlightedImage hImg: UIImage? = nil) {
        let frame = CGRect(x: 0, y: 0, width: img?.size.width ?? 0, height: img?.size.height ?? 0)
        
        self.init(frame: frame)
        
        image = img
        highlightedImage = hImg
    }
    
    public convenience init(frame: CGRect, image img: UIImage?, highlightedImage hImg: UIImage? = nil) {
        self.init(frame: frame)
     
        image = img
        highlightedImage = hImg
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clearColor()
        userInteractionEnabled = false
    }

    // MARK: - Drawing
    
    public override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        // clears the view if there is no image to draw
        guard let image = highlighted ? highlightedImage : image else { return CGContextDrawImage(context, rect, nil) }
        
        // get content rect
        let contentRect = contentModeRectForImage(image)
        
        // saves the graphics state
        CGContextSaveGState(context)
        
        // flip the context so that the image is rendered right side up.
        CGContextTranslateCTM(context, 0.0, bounds.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        
        // Scale the context so that the image is rendered at the correct size for the zoom level.
        CGContextScaleCTM(context, 1.0, 1.0)
        
        // draw the image
        if highlighted {
            // set blend mode
            CGContextSetBlendMode(context, .Normal)
            
            // get template image
            let templateImage = image.imageWithRenderingMode(.AlwaysTemplate)
            
            // mask image clipping path
            CGContextClipToMask(context, contentRect, templateImage.CGImage)

            // set blend mode
            CGContextSetBlendMode(context, .Color)
            
            // set tinting color
            let tintingColor = tintColor ?? UIColor.blackColor()
            tintingColor.set()
            tintingColor.setFill()
            
            // draw image in context
            CGContextDrawImage(context, contentRect, templateImage.CGImage)
            
            // fill clipped path
            UIRectFill(contentRect)
        }else{
            CGContextDrawImage(context, contentRect, image.CGImage)
        }
        
        // restores the graphics state
        CGContextRestoreGState(context)
    }
    
    public override func tintColorDidChange() {
        setNeedsDisplay()
    }
    
    // Helpers
    
    // MARK: - Drawing Helpers
    
    private func contentModeRectForImage(image: UIImage) -> CGRect {
        let imageSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
        
        switch contentViewMode {
            
        case .OriginalSize: // image size is retained
            return caculateContentViewFillRectForImageSize(imageSize)
            
        case .AspectFit: // contents scaled to fit with fixed aspect. remainder is transparent
            
            var scaling: CGFloat = 1.0
            let boundsMinSize = bounds.width < bounds.height ? bounds.width : bounds.height
            
            if imageSize.width < imageSize.height {
                scaling = boundsMinSize / imageSize.width
            }else{
                scaling = boundsMinSize / imageSize.height
            }
            
            let scaledImageSize = CGSize(width: imageSize.width * scaling, height: imageSize.height * scaling)
            return caculateContentViewFillRectForImageSize(scaledImageSize)
            
        case .AspectFill: // contents scaled to fill with fixed aspect. some portion of content will be clipped.
            
            var scaling: CGFloat = 1.0
            let boundsMaxSize = bounds.width > bounds.height ? bounds.width : bounds.height
            
            if imageSize.width > imageSize.height {
                scaling = boundsMaxSize / imageSize.width
            }else{
                scaling = boundsMaxSize / imageSize.height
            }
            
            let scaledImageSize = CGSize(width: imageSize.width * scaling, height: imageSize.height * scaling)
            return caculateContentViewFillRectForImageSize(scaledImageSize)
            
        default: break
            
        }
        
        // .ScaleToFill
        return CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
    
    private func caculateContentViewFillRectForImageSize(imageSize: CGSize) -> CGRect {
        
        // .Center fill
        var originX: CGFloat = (bounds.width - imageSize.width) / 2
        var originY: CGFloat = (bounds.height - imageSize.height) / 2
        
        if contentViewFill.contains(.Left) {
            originX = 0
        }else if contentViewFill.contains(.Right) {
            originX = (bounds.width - imageSize.width)
        }
        
        if contentViewFill.contains(.Top) {
            originY = 0
        }else if contentViewFill.contains(.Bottom) {
            originY = (bounds.height - imageSize.height)
        }
        
        let contentRect = CGRect(x: originX, y: originY, width: imageSize.width, height: imageSize.height)
        return flipContentRect(contentRect)
    }
    
    private func flipContentRect(contentRect: CGRect) -> CGRect {
        // get transform
        let transform = CGAffineTransformMakeTranslation(0.0, bounds.height)
        // flip transform
        let flipTransform = CGAffineTransformScale(transform, 1.0, -1.0)
        // apply transform to target rect
        let flipContentRect = CGRectApplyAffineTransform(contentRect, flipTransform)
        
        return flipContentRect
    }

    
    // MARK: - Loaders
    
    private func prepareLoadingIndicator() -> UIActivityIndicatorView {
        
        let loadingIndicatorFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let loadingIndicator = UIActivityIndicatorView(frame: loadingIndicatorFrame)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = .Gray
        
        addSubview(loadingIndicator)
        bringSubviewToFront(loadingIndicator)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: loadingIndicator, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0.0)
        let trailing = NSLayoutConstraint(item: loadingIndicator, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0.0)
        let bottom = NSLayoutConstraint(item: loadingIndicator, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0.0)
        let leading = NSLayoutConstraint(item: loadingIndicator, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0.0)
        
        addConstraints([top, trailing, bottom, leading])
        
        return loadingIndicator
    }
    
    private func prepareLoadingProgressView() -> UIProgressView {
        
        let progressView = UIProgressView(progressViewStyle: .Default)
        progressView.progressTintColor = .cyanColor()
        progressView.trackTintColor = .lightGrayColor()
        progressView.hidden = true
        progressView.alpha = 0.0
        
        addSubview(progressView)
        bringSubviewToFront(progressView)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        let trailing = NSLayoutConstraint(item: progressView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0.0)
        let bottom = NSLayoutConstraint(item: progressView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0.0)
        let leading = NSLayoutConstraint(item: progressView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0.0)
        
        self.addConstraints([trailing, bottom, leading])
        
        return progressView
    }
    
    private func prepareVisualBlurEffectView() -> UIVisualEffectView {
        
        let effect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = bounds
        blurView.hidden = true
        
        addSubview(blurView)
        sendSubviewToBack(blurView)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: blurView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0.0)
        let trailing = NSLayoutConstraint(item: blurView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0.0)
        let bottom = NSLayoutConstraint(item: blurView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0.0)
        let leading = NSLayoutConstraint(item: blurView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0.0)
        
        addConstraints([top, trailing, bottom, leading])
        
        return blurView
    }
    
    // MARK: - Request Manager
    
    internal func loadImageWithSpinner(imageURL: NSURL, completion: NFImageViewRequestCompletion? = nil) {
        if let receipt = requestReceipt {
            receipt.request.cancel()
            if let canceledURLRequest = receipt.request.request?.URL {
                dispatch_async(NFImageCacheAPI.sharedAPI.imageDownloadQueue, {
                    NFImageCacheAPI.sharedAPI.downloadImage(canceledURLRequest)
                })
            }
            requestReceipt = nil
        }
        
        forceStartLoadingState()
        
        requestReceipt = NFImageCacheAPI.sharedAPI.downloadImage(imageURL, completion: { (response) in
            
            if let image = response.result.value {
                self.forceStopLoadingState()
                
                self.image = image
                completion?(code: .Success, error: nil)
            }else{
                if let errorCode = response.result.error?.code where errorCode != NFImageViewRequestCode.Canceled.rawValue {
                    self.forceStopLoadingState()
                    completion?(code: .Unknown, error: response.result.error)
                }else{
                    completion?(code: .Canceled, error: response.result.error)
                }
            }
        })
    }
    
    internal func loadImageWithProgress(imageURL: NSURL, shouldContinueLoading: Bool = false, completion: NFImageViewRequestCompletion? = nil) {
        if let receipt = requestReceipt {
            receipt.request.cancel()
            if let canceledURLRequest = receipt.request.request?.URL {
                dispatch_async(NFImageCacheAPI.sharedAPI.imageDownloadQueue, {
                    NFImageCacheAPI.sharedAPI.downloadImage(canceledURLRequest)
                })
            }
            requestReceipt = nil
        }
        
        forceStartLoadingState()
        
        requestReceipt = NFImageCacheAPI.sharedAPI.downloadImageWithProgress(imageURL, progress: { (bytesRead, totalBytesRead, totalExpectedBytesToRead) in
            
            let progress = Float(totalBytesRead) / Float(totalExpectedBytesToRead)
            self.loadingProgressView.setProgress(progress, animated: true)
            
        }) { (response) in
            
            if let image = response.result.value {
                if !shouldContinueLoading {
                    self.forceStopLoadingState()
                }
                
                self.image = image
                completion?(code: .Success, error: nil)
            }else{
                if let errorCode = response.result.error?.code where errorCode != NFImageViewRequestCode.Canceled.rawValue {
                    if !shouldContinueLoading {
                        self.forceStopLoadingState()
                    }
                    
                    completion?(code: .Unknown, error: response.result.error)
                }else{
                    completion?(code: .Canceled, error: response.result.error)
                }
            }
        }
    }
    
    /**
     * Use when loading is disabled
     */
    internal func loadImage(imageURL: NSURL, completion: NFImageViewRequestCompletion? = nil) {
        if let receipt = requestReceipt {
            receipt.request.cancel()
            if let canceledURLRequest = receipt.request.request?.URL {
                dispatch_async(NFImageCacheAPI.sharedAPI.imageDownloadQueue, {
                    NFImageCacheAPI.sharedAPI.downloadImage(canceledURLRequest)
                })
            }
            requestReceipt = nil
        }
        
        requestReceipt = NFImageCacheAPI.sharedAPI.downloadImage(imageURL, completion: { (response) in
            
            if let image = response.result.value {
                self.image = image
                completion?(code: .Success, error: nil)
            }else{
                if let errorCode = response.result.error?.code where errorCode != NFImageViewRequestCode.Canceled.rawValue {
                    completion?(code: .Unknown, error: response.result.error)
                }else{
                    completion?(code: .Canceled, error: response.result.error)
                }
            }
        })
    }
    
}