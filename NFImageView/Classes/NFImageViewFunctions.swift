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
    public func setImage(fromURLString URLString: String, completion: NFImageViewRequestCompletion? = nil) {
        if !URLString.isEmpty, let imageURL = URL(string: URLString) {
            setImage(fromURL: imageURL, completion: completion)
        }
    }
    
    /**
     * Set image from image URL
     */
    public func setImage(fromURL imageURL: URL, completion: NFImageViewRequestCompletion? = nil) {
        
        if !loadingEnabled {
            loadImage(fromURL: imageURL, completion: completion)
        }else{
            switch loadingType {
            case .progress:
                loadWithProgress(imageURL: imageURL, completion: completion)
                
            default:
                loadWithSpinner(imageURL: imageURL, completion: completion)
            }
        }
    }
    
    /**
     * Set thumbnail and large image from URL sting with blur effect transition
     */
    public func setThumbImageAndLargeImage(fromURLString thumbURLString: String, largeURLString: String, completion: NFImageViewRequestCompletion? = nil) {
        
        if !thumbURLString.isEmpty && !largeURLString.isEmpty, let thumbURL = URL(string: thumbURLString), let largeURL = URL(string: largeURLString) {
            
            if let cachedImage = NFImageCacheAPI.shared.imageContentInCacheStorage(forURL: largeURL) {
                image = cachedImage
                
                // update cache for url request
                NFImageCacheAPI.shared.downloadQueue.async(execute: {
                    let _ = NFImageCacheAPI.shared.download(imageURL: thumbURL)
                    let _ = NFImageCacheAPI.shared.download(imageURL: largeURL)
                })
            }else{
                setThumbImageAndLargeImage(fromURL: thumbURL, largeURL: largeURL)
            }
        }
    }
    
    /**
     * Set thumbnail and large image from URL with blur effect transition
     */
    public func setThumbImageAndLargeImage(fromURL thumbURL: URL, largeURL: URL, completion: NFImageViewRequestCompletion? = nil) {
        
        if !loadingEnabled {
            loadImage(fromURL: thumbURL, completion: { (code, error) in
                if code == .success {
                    self.loadImage(fromURL: largeURL, completion: { (code, error) in
                        completion?(code, error)
                    })
                }else{
                    completion?(code, error)
                }
            })
        }else{
            blurEffect.isHidden = false
            
            switch loadingType {
            case .progress:
                loadWithProgress(imageURL: thumbURL, shouldContinueLoading: true, completion: { (code, error) in
                    if code == .success {
                        self.loadWithProgress(imageURL: largeURL, completion: { (code, error) in
                            
                            self.blurEffect.isHidden = true
                            completion?(code, error)
                        })
                    }else{
                        self.blurEffect.isHidden = true
                        completion?(code, error)
                    }
                })
                
            default:
                loadWithSpinner(imageURL: thumbURL, completion: { (code, error) in
                    if code == .success {
                        self.loadWithSpinner(imageURL: largeURL, completion: { (code, error) in
                            
                            self.blurEffect.isHidden = true
                            completion?(code, error)
                        })
                    }else{
                        self.blurEffect.isHidden = true
                        completion?(code, error)
                    }
                })
            }
        }
    }
}
