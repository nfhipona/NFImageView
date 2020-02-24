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

@IBDesignable
open class NFImageView: UIView {
    
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
    
    open var contentViewMode: ViewContentMode = .aspectFill {
        didSet { setNeedsDisplay() }
    }
    
    open var contentViewFill: ViewContentFill = .Center {
        didSet { setNeedsDisplay() }
    }
    
    open var loadingType: NFImageViewLoadingType = .default {
        didSet { setNeedsDisplay() }
    }
    
    // MARK: - IBInspectables
    
    @IBInspectable open var loadingEnabled: Bool = true
    
    @IBInspectable open var highlighted: Bool = false {
        didSet { setNeedsDisplay() }
    }
    
    // default is nil
    @IBInspectable open var image: UIImage? {
        didSet { setNeedsDisplay() }
    }
    
    // default is nil
    @IBInspectable open var highlightedImage: UIImage? {
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
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        isUserInteractionEnabled = false
        
        setNeedsDisplay()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    // MARK: - Drawing
    
    open override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // clears the view if there is no image to draw
        guard let image = highlighted ? highlightedImage : image else { return context.clear(rect) }
        
        // get content rect
        let contentRect = contentModeRect(forImage: image)
        
        // saves the graphics state
        context.saveGState()
        
        // flip the context so that the image is rendered right side up.
        context.translateBy(x: 0.0, y: bounds.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        // Scale the context so that the image is rendered at the correct size for the zoom level.
        context.scaleBy(x: 1.0, y: 1.0)
        
        // draw the image
        if highlighted {
            // set blend mode
            context.setBlendMode(.normal)
            
            // get template image
            let templateImage = image.withRenderingMode(.alwaysTemplate)
            // handle cgimage
            guard let templateCGImage = templateImage.cgImage else { return context.clear(rect) }
            
            // mask image clipping path
            context.clip(to: contentRect, mask: templateCGImage)
            
            // set blend mode
            context.setBlendMode(.color)
            
            // set tinting color
            let tintingColor = tintColor ?? UIColor.black
            tintingColor.set()
            tintingColor.setFill()
            
            // draw image in context
            context.draw(templateCGImage, in: contentRect)
            
            // fill clipped path
            UIRectFill(contentRect)
        }else{
            // handle cgimage
            guard let imageCG = image.cgImage else { return context.clear(rect) }
            
            // draw image in context
            context.draw(imageCG, in: contentRect)
        }
        
        // restores the graphics state
        context.restoreGState()
    }
    
    open override func tintColorDidChange() {
        setNeedsDisplay()
    }
    
    // Helpers
    
    // MARK: - Drawing Helpers
    
    fileprivate func contentModeRect(forImage image: UIImage) -> CGRect {
        let imageSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
        
        switch contentViewMode {
            
        case .originalSize: // image size is retained
            return caculateContentViewImageFillRect(forSize: imageSize)
            
        case .aspectFit: // contents scaled to fit with fixed aspect. remainder is transparent
            
            var scaling: CGFloat = 1.0
            let imageMaxSize = imageSize.width > imageSize.height ? imageSize.width : imageSize.height
            
            // get max container bounds
            if bounds.width > bounds.height {
                // get max scale of max image bounds to container max bounds
                let maxScale = bounds.width / imageMaxSize
                // check if image height would exceed the container bounds
                if imageSize.height * maxScale > bounds.height {
                    // use the image height if it exceeds the bounds of the container
                    scaling = bounds.height / imageSize.height
                }else{
                    scaling = maxScale
                }
            }else{
                // get max scale of max image bounds to container max bounds
                let maxScale = bounds.height / imageMaxSize
                // check if image height would exceed the container bounds
                if imageSize.width * maxScale > bounds.width {
                    // use the image height if it exceeds the bounds of the container
                    scaling = bounds.width / imageSize.width
                }else{
                    scaling = maxScale
                }
            }
            
            let scaledImageSize = CGSize(width: imageSize.width * scaling, height: imageSize.height * scaling)
            return caculateContentViewImageFillRect(forSize: scaledImageSize)
            
        case .aspectFill: // contents scaled to fill with fixed aspect. some portion of content will be clipped.
            
            var scaling: CGFloat = 1.0
            let widthMargin = bounds.width - imageSize.width
            let heightMargin = bounds.height - imageSize.height
            
            if abs(widthMargin) < abs(heightMargin) {
                if widthMargin > heightMargin {
                    scaling = bounds.width / imageSize.width
                }else{
                    scaling = bounds.height / imageSize.height
                }
            }else{
                if widthMargin > heightMargin {
                    scaling = bounds.width / imageSize.width
                }else{
                    scaling = bounds.height / imageSize.height
                }
                
                if imageSize.width * scaling < bounds.width || imageSize.height * scaling < bounds.height {
                    if imageSize.width * scaling < bounds.width {
                        scaling = bounds.width / imageSize.width
                    }else{
                        scaling = bounds.height / imageSize.height
                    }
                }
            }
            
            let scaledImageSize = CGSize(width: imageSize.width * scaling, height: imageSize.height * scaling)
            return caculateContentViewImageFillRect(forSize: scaledImageSize)
            
        default: break
            
        }
        
        // .ScaleToFill
        return CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
    
    fileprivate func caculateContentViewImageFillRect(forSize imageSize: CGSize) -> CGRect {
        
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
    
    fileprivate func flipContentRect(_ contentRect: CGRect) -> CGRect {
        // get transform
        let transform = CGAffineTransform(translationX: 0.0, y: bounds.height)
        // flip transform
        let flipTransform = transform.scaledBy(x: 1.0, y: -1.0)
        // apply transform to target rect
        let flipContentRect = contentRect.applying(flipTransform)
        
        return flipContentRect
    }
    
    
    // MARK: - Loaders Setup
    
    fileprivate func prepareLoadingIndicator() -> UIActivityIndicatorView {
        
        let loadingIndicatorFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let loadingIndicator = UIActivityIndicatorView(frame: loadingIndicatorFrame)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .gray
        
        addSubview(loadingIndicator)
        bringSubviewToFront(loadingIndicator)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: loadingIndicator, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0.0)
        let trailing = NSLayoutConstraint(item: loadingIndicator, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0.0)
        let bottom = NSLayoutConstraint(item: loadingIndicator, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0.0)
        let leading = NSLayoutConstraint(item: loadingIndicator, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0.0)
        
        addConstraints([top, trailing, bottom, leading])
        
        return loadingIndicator
    }
    
    fileprivate func prepareLoadingProgressView() -> UIProgressView {
        
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .cyan
        progressView.trackTintColor = .lightGray
        progressView.isHidden = true
        progressView.alpha = 0.0
        
        addSubview(progressView)
        bringSubviewToFront(progressView)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        let trailing = NSLayoutConstraint(item: progressView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0.0)
        let bottom = NSLayoutConstraint(item: progressView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0.0)
        let leading = NSLayoutConstraint(item: progressView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0.0)
        
        self.addConstraints([trailing, bottom, leading])
        
        return progressView
    }
    
    fileprivate func prepareVisualBlurEffectView() -> UIVisualEffectView {
        
        let effect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = bounds
        blurView.isHidden = true
        
        addSubview(blurView)
        sendSubviewToBack(blurView)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: blurView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0.0)
        let trailing = NSLayoutConstraint(item: blurView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0.0)
        let bottom = NSLayoutConstraint(item: blurView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0.0)
        let leading = NSLayoutConstraint(item: blurView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0.0)
        
        addConstraints([top, trailing, bottom, leading])
        
        return blurView
    }
}
