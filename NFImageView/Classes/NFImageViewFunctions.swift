//
//  NFImageViewFunctions.swift
//  Pods
//
//  Created by Neil Francis Hipona on 23/07/2016.
//
//

import Foundation
import UIKit

// MARK: - Public Functions

extension NFImageView {

    /**
     * Force starting image loading
     */
    public func forceStartLoadingState() {
        if !loadingEnabled { return }
        
        switch loadingType {
        case .Progress:
            loadingProgressView.hidden = false
            loadingProgressView.progress = 0.0
            loadingProgressView.alpha = 0.0
            
            UIView.animateWithDuration(0.25, animations: {
                self.loadingProgressView.alpha = 1.0
            })
            
        default:
            loadingIndicator.startAnimating()
        }
    }
    
    /**
     * Force stopping image loading
     */
    public func forceStopLoadingState() {
        if !loadingEnabled { return }
        
        switch loadingType {
        case .Progress:
            
            loadingProgressView.alpha = 1.0
            loadingProgressView.setProgress(0.0, animated: true)
            UIView.animateWithDuration(0.25, animations: {
                self.loadingProgressView.alpha = 0.0
                }, completion: { _ in
                    self.loadingProgressView.hidden = true
            })
            
        default:
            loadingIndicator.stopAnimating()
        }
    }
    
    /**
     * Stop issued image download request
     */
    public func cancelLoadImageRequest() {
        requestReceipt?.request.cancel()
    }
    
    /**
     * Set image from image URL string
     */
    public func setImageFromURLString(URLString: String, completion: NFImageViewRequestCompletion? = nil) {
        if !URLString.isEmpty, let imageURL = NSURL(string: URLString) {
            setImageFromURL(imageURL, completion: completion)
        }
    }
    
    /**
     * Set image from image URL
     */
    public func setImageFromURL(imageURL: NSURL, completion: NFImageViewRequestCompletion? = nil) {
        
        if !loadingEnabled {
            loadImage(imageURL, completion: completion)
        }else{
            switch loadingType {
            case .Progress:
                loadImageWithProgress(imageURL, completion: completion)
                
            default:
                loadImageWithSpinner(imageURL, completion: completion)
            }
        }
    }
    
    /**
     * Set thumbnail and large image from URL sting with blur effect transition
     */
    public func setThumbImageAndLargeImageFromURLString(thumbURLString thumbURLString: String, largeURLString: String, completion: NFImageViewRequestCompletion? = nil) {
        
        if !thumbURLString.isEmpty && !largeURLString.isEmpty, let thumbURL = NSURL(string: thumbURLString), let largeURL = NSURL(string: largeURLString) {
            
            if let cachedImage = NFImageCacheAPI.sharedAPI.checkForImageContentInCacheStorage(largeURL) {
                image = cachedImage
                
                // update cache for url request
                dispatch_async(NFImageCacheAPI.sharedAPI.imageDownloadQueue, {
                    NFImageCacheAPI.sharedAPI.downloadImage(thumbURL)
                    NFImageCacheAPI.sharedAPI.downloadImage(largeURL)
                })
            }else{
                setThumbImageAndLargeImageFromURL(thumbURL: thumbURL, largeURL: largeURL)
            }
        }
    }
    
    /**
     * Set thumbnail and large image from URL with blur effect transition
     */
    public func setThumbImageAndLargeImageFromURL(thumbURL thumbURL: NSURL, largeURL: NSURL, completion: NFImageViewRequestCompletion? = nil) {
        
        if !loadingEnabled {
            loadImage(thumbURL, completion: { (code, error) in
                if code == .Success {
                    self.loadImage(largeURL, completion: { (code, error) in
                        completion?(code: code, error: error)
                    })
                }else{
                    completion?(code: code, error: error)
                }
            })
        }else{
            blurEffect.hidden = false
            
            switch loadingType {
            case .Progress:
                loadImageWithProgress(thumbURL, shouldContinueLoading: true, completion: { (code, error) in
                    if code == .Success {
                        self.loadImageWithProgress(largeURL, completion: { (code, error) in
                            
                            self.blurEffect.hidden = true
                            completion?(code: code, error: error)
                        })
                    }else{
                        self.blurEffect.hidden = true
                        completion?(code: code, error: error)
                    }
                })
                
            default:
                loadImageWithSpinner(thumbURL, completion: { (code, error) in
                    if code == .Success {
                        self.loadImageWithSpinner(largeURL, completion: { (code, error) in
                            
                            self.blurEffect.hidden = true
                            completion?(code: code, error: error)
                        })
                    }else{
                        self.blurEffect.hidden = true
                        completion?(code: code, error: error)
                    }
                })
            }
        }
    }
}