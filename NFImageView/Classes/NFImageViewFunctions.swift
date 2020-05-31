//
//  NFImageViewFunctions.swift
//  Pods
//
//  Created by Neil Francis Hipona on 23/07/2016.
//  Copyright (c) 2016 Neil Francis Ramirez Hipona. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Public Functions - Loaders

extension NFImageView {
    
    /**
     * Force starting image loading
     */
    public func forceStartLoadingState(isBlurEnabled: Bool = false) {
        if !loadingEnabled { return }
        
        blurEffect.isHidden = !isBlurEnabled
        
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
        
        blurEffect.isHidden = true
        
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
     * Stop issued image load request
     */
    public func cancelImageLoadRequest() {
        requestReceipt?.request.cancel()
    }
}

// MARK: - Public Functions - Image Setters

extension NFImageView {
    
    /**
     * Set image from image URL string
     */
    public func setImage(fromURLString URLString: String, placeholder: UIImage? = nil, completion: NFImageViewRequestCompletion? = nil) {
        
        if !URLString.isEmpty, let imageURL = URL(string: URLString) {
            
            if let cachedImage = NFImageCacheAPI.shared.imageContentInCacheStorage(forURL: imageURL) {
                image = cachedImage
                
                // update cache for url request
                NFImageCacheAPI.shared.downloadQueue.async(execute: {
                    let _ = NFImageCacheAPI.shared.download(imageURL: imageURL)
                })
                
                completion?(.success, nil)
            }else{
                setImage(fromURL: imageURL, placeholder: placeholder, completion: completion)
            }
        }else{
            image = placeholder
        }
    }
    
    /**
     * Set image from image URL
     */
    public func setImage(fromURL imageURL: URL, placeholder: UIImage? = nil, completion: NFImageViewRequestCompletion? = nil) {
        image = placeholder
        
        if !loadingEnabled {
            loadImage(fromURL: imageURL, completion: completion)
        }else{
            forceStartLoadingState()
            
            switch loadingType {
            case .progress:
                loadWithProgress(imageURL: imageURL) { (code, error) in
                    self.forceStopLoadingState()
                    completion?(code, error)
                }
                
            default:
                loadWithSpinner(imageURL: imageURL) { (code, error) in
                    self.forceStopLoadingState()
                    completion?(code, error)
                }
            }
        }
    }
    
    /**
     * Set thumbnail and large image from URL sting with blur effect transition
     */
    public func setThumbImageAndLargeImage(fromURLString thumbURLString: String, largeURLString: String, placeholder: UIImage? = nil, completion: NFImageViewRequestCompletion? = nil) {
        
        if !thumbURLString.isEmpty && !largeURLString.isEmpty, let thumbURL = URL(string: thumbURLString), let largeURL = URL(string: largeURLString) {
            
            if let cachedImage = NFImageCacheAPI.shared.imageContentInCacheStorage(forURL: largeURL) {
                image = cachedImage
                
                // update cache for url request
                NFImageCacheAPI.shared.downloadQueue.async(execute: {
                    let _ = NFImageCacheAPI.shared.download(imageURL: largeURL)
                })
                
                completion?(.success, nil)
            }else{
                setThumbImageAndLargeImage(fromURL: thumbURL, largeURL: largeURL, placeholder: placeholder, completion: completion)
            }
        }else{
            image = placeholder
        }
    }
    
    /**
     * Set thumbnail and large image from URL with blur effect transition
     */
    public func setThumbImageAndLargeImage(fromURL thumbURL: URL, largeURL: URL, placeholder: UIImage? = nil, completion: NFImageViewRequestCompletion? = nil) {
        image = placeholder
        
        if !loadingEnabled {
            loadImage(fromURL: thumbURL, completion: { (code, error) in
                if code != .canceled {
                    self.loadImage(fromURL: largeURL, completion: { (code, error) in
                        completion?(code, error)
                    })
                }else{
                    completion?(code, error)
                }
            })
        }else{
            forceStartLoadingState(isBlurEnabled: true)
            
            switch loadingType {
            case .progress:
                loadWithProgress(imageURL: thumbURL, completion: { (code, error) in
                    if code != .canceled {
                        self.loadWithProgress(imageURL: largeURL, completion: { (code, error) in
                            self.forceStopLoadingState()
                            completion?(code, error)
                        })
                    }else{
                        self.forceStopLoadingState()
                        completion?(code, error)
                    }
                })
                
            default:
                loadWithSpinner(imageURL: thumbURL, completion: { (code, error) in
                    if code != .canceled {
                        self.loadWithSpinner(imageURL: largeURL, completion: { (code, error) in
                            self.forceStopLoadingState()
                            completion?(code, error)
                        })
                    }else{
                        self.forceStopLoadingState()
                        completion?(code, error)
                    }
                })
            }
        }
    }
}
