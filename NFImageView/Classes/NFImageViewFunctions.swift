//
//  NFImageViewFunctions.swift
//  Pods
//
//  Created by Neil Francis Hipona on 23/07/2016.
//  Copyright (c) 2016 Neil Francis Ramirez Hipona. All rights reserved.
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
        case .progress:
            loadingProgressView.isHidden = false
            loadingProgressView.progress = 0.0
            loadingProgressView.alpha = 0.0
            
            UIView.animate(withDuration: 0.25, animations: {
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
        case .progress:
            
            loadingProgressView.alpha = 1.0
            loadingProgressView.setProgress(0.0, animated: true)
            UIView.animate(withDuration: 0.25, animations: {
                self.loadingProgressView.alpha = 0.0
                }, completion: { _ in
                    self.loadingProgressView.isHidden = true
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
    public func setImageFromURLString(_ URLString: String, completion: NFImageViewRequestCompletion? = nil) {
        if !URLString.isEmpty, let imageURL = URL(string: URLString) {
            setImageFromURL(imageURL, completion: completion)
        }
    }
    
    /**
     * Set image from image URL
     */
    public func setImageFromURL(_ imageURL: URL, completion: NFImageViewRequestCompletion? = nil) {
        
        if !loadingEnabled {
            loadImage(imageURL, completion: completion)
        }else{
            switch loadingType {
            case .progress:
                loadImageWithProgress(imageURL, completion: completion)
                
            default:
                loadImageWithSpinner(imageURL, completion: completion)
            }
        }
    }
    
    /**
     * Set thumbnail and large image from URL sting with blur effect transition
     */
    public func setThumbImageAndLargeImageFromURLString(thumbURLString: String, largeURLString: String, completion: NFImageViewRequestCompletion? = nil) {
        
        if !thumbURLString.isEmpty && !largeURLString.isEmpty, let thumbURL = URL(string: thumbURLString), let largeURL = URL(string: largeURLString) {
            
            if let cachedImage = NFImageCacheAPI.sharedAPI.checkForImageContentInCacheStorage(largeURL) {
                image = cachedImage
                
                // update cache for url request
                NFImageCacheAPI.sharedAPI.imageDownloadQueue.async(execute: {
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
    public func setThumbImageAndLargeImageFromURL(thumbURL: URL, largeURL: URL, completion: NFImageViewRequestCompletion? = nil) {
        
        if !loadingEnabled {
            loadImage(thumbURL, completion: { (code, error) in
                if code == .success {
                    self.loadImage(largeURL, completion: { (code, error) in
                        completion?(code: code, error: error)
                    })
                }else{
                    completion?(code: code, error: error)
                }
            })
        }else{
            blurEffect.isHidden = false
            
            switch loadingType {
            case .progress:
                loadImageWithProgress(thumbURL, shouldContinueLoading: true, completion: { (code, error) in
                    if code == .success {
                        self.loadImageWithProgress(largeURL, completion: { (code, error) in
                            
                            self.blurEffect.isHidden = true
                            completion?(code: code, error: error)
                        })
                    }else{
                        self.blurEffect.isHidden = true
                        completion?(code: code, error: error)
                    }
                })
                
            default:
                loadImageWithSpinner(thumbURL, completion: { (code, error) in
                    if code == .success {
                        self.loadImageWithSpinner(largeURL, completion: { (code, error) in
                            
                            self.blurEffect.isHidden = true
                            completion?(code: code, error: error)
                        })
                    }else{
                        self.blurEffect.isHidden = true
                        completion?(code: code, error: error)
                    }
                })
            }
        }
    }
}
