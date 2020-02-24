//
//  NFImageViewDrawFunctions.swift
//  NFImageView
//
//  Created by Neil Francis Hipona on 2/24/20.
//

import Foundation

// MARK: - Drawing Helpers

extension NFImageView {
    
    internal func contentModeRect(forImage image: UIImage) -> CGRect {
        let imageSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
        
        switch contentViewMode {
            
        case .originalSize: // image size is retained
            return caculateContentViewImageFillRect(forSize: imageSize)
            
        case .aspectFit: // contents scaled to fit with fixed aspect. remainder is transparent
            
            let scaling = getFitRatio(forCanvas: bounds.size, itemSize: imageSize)
            let scaledImageSize = CGSize(width: imageSize.width * scaling, height: imageSize.height * scaling)
            
            return caculateContentViewImageFillRect(forSize: scaledImageSize)
            
        case .aspectFill: // contents scaled to fill with fixed aspect. some portion of content will be clipped.
            
            let scaling = getFillRatio(forCanvas: bounds.size, itemSize: imageSize)
            let scaledImageSize = CGSize(width: imageSize.width * scaling, height: imageSize.height * scaling)
            
            return caculateContentViewImageFillRect(forSize: scaledImageSize)
            
        default: break
            
        }
        
        // .ScaleToFill
        return CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
    
    internal func caculateContentViewImageFillRect(forSize imageSize: CGSize) -> CGRect {
        
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
    
    internal func flipContentRect(_ contentRect: CGRect) -> CGRect {
        // get transform
        let transform = CGAffineTransform(translationX: 0.0, y: bounds.height)
        // flip transform
        let flipTransform = transform.scaledBy(x: 1.0, y: -1.0)
        // apply transform to target rect
        let flipContentRect = contentRect.applying(flipTransform)
        
        return flipContentRect
    }
    
    fileprivate func getScale(forCanvas canvas: CGFloat, itemSize: CGFloat) -> CGFloat {
        
        return canvas / itemSize
    }
    
    fileprivate func getFitRatio(forCanvas canvas: CGSize, itemSize: CGSize) -> CGFloat {
        
        let ratio = getScale(forCanvas: canvas.width, itemSize: itemSize.width)
        
        // validate ratio to canvas size
        if ratio * itemSize.height > canvas.height { // invalid
            // flip values
            let flippedCanvas = CGSize(width: canvas.height, height: canvas.width)
            let flippedItemSize = CGSize(width: itemSize.height, height: itemSize.width)
            return getFitRatio(forCanvas: flippedCanvas, itemSize: flippedItemSize)
        }
        
        return ratio
    }
    
    fileprivate func getFillRatio(forCanvas canvas: CGSize, itemSize: CGSize) -> CGFloat {
        
        let ratio = getScale(forCanvas: canvas.width, itemSize: itemSize.width)
        
        // validate ratio to canvas size
        if ratio * itemSize.height < canvas.height { // invalid
            // flip values
            let flippedCanvas = CGSize(width: canvas.height, height: canvas.width)
            let flippedItemSize = CGSize(width: itemSize.height, height: itemSize.width)
            return getFillRatio(forCanvas: flippedCanvas, itemSize: flippedItemSize)
        }
        
        return ratio
    }
}
