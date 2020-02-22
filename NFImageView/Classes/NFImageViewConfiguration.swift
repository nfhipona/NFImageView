//
//  NFImageViewConfiguration.swift
//  Pods
//
//  Created by Neil Francis Hipona on 23/07/2016.
//  Copyright (c) 2016 Neil Francis Ramirez Hipona. All rights reserved.
//

import Foundation
import UIKit


extension NFImageView {
    
    // MARK: - UIActivityIndicatorView Configuration
    
    /**
     * Set loading spinner's spinner color
     */
    public func setLoadingSpinnerColor(_ color: UIColor) {
        loadingIndicator.color = color
    }
    
    /**
     * Set loading spinner's spinner style
     */
    public func setLoadingSpinnerViewStyle(activityIndicatorViewStyle style: UIActivityIndicatorView.Style) {
        loadingIndicator.style = style
    }
    
    /**
     * Set loading spinner's background color
     */
    public func setLoadingSpinnerBackgroundColor(_ color: UIColor) {
        loadingIndicator.backgroundColor = color
    }
    
    
    // MARK: - UIProgressView Configuration
    
    /**
     * Set loading progress view style
     */
    public func setLoadingProgressViewStyle(progressViewStyle style: UIProgressView.Style) {
        loadingProgressView.progressViewStyle = style
    }
    
    /**
     * Set loading progress tint color
     */
    public func setLoadingProgressViewTintColor(_ progressTintColor: UIColor?, trackTintColor: UIColor?) {
        
        loadingProgressView.progressTintColor = progressTintColor
        loadingProgressView.trackTintColor = trackTintColor
    }
    
    /**
     * Set loading progress image
     */
    public func setLoadingProgressViewProgressImage(_ progressImage: UIImage?, trackImage: UIImage?) {
        
        loadingProgressView.progressImage = progressImage
        loadingProgressView.trackImage = trackImage
    }
    
    /**
     * Set loading progress's progress value
     */
    public func setLoadingProgressViewProgress(_ progress: Float, animated: Bool) {
        loadingProgressView.setProgress(progress, animated: animated)
    }
}
