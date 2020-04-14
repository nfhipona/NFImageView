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

// MARK: - Enum

extension NFImageView {
    
    public enum ContentMode: Int {
        
        case fill // will fill the entire bounds
        case aspectFit // contents scaled to fit with fixed aspect. remainder is transparent
        case aspectFill // contents scaled to fill with fixed aspect. some portion of content may be clipped.
        case originalSize // image size is retained
    }

    public struct ContentFill: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        
        /// The option to align the content to the center.
        public static let Center = ContentFill([])
        /// The option to align the content to the left.
        public static let Left = ContentFill(rawValue: 1)
        /// The option to align the content to the right.
        public static let Right = ContentFill(rawValue: 2)
        /// The option to align the content to the top.s
        public static let Top = ContentFill(rawValue: 4)
        /// The option to align the content to the bottom.
        public static let Bottom = ContentFill(rawValue: 8)
        /// The option to align the content to the top left.
        public static let TopLeft: ContentFill = [Top, Left]
        /// The option to align the content to the top right.
        public static let TopRight: ContentFill = [Top, Right]
        /// The option to align the content to the bottom left.
        public static let BottomLeft: ContentFill = [Bottom, Left]
        /// The option to align the content to the bottom right.
        public static let BottomRight: ContentFill = [Bottom, Right]
    }
}

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
    
    open var contentViewMode: ContentMode = .aspectFill {
        didSet { setNeedsDisplay() }
    }
    
    open var contentViewFill: ContentFill = .Center {
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
    
    // MARK: - Loaders Setup
    
    fileprivate func prepareLoadingIndicator() -> UIActivityIndicatorView {
        
        let loadingIndicatorFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let loadingIndicator = UIActivityIndicatorView(frame: loadingIndicatorFrame)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        
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
