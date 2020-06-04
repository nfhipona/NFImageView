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
            loadingProgressView.progress = 0.0
            loadingProgressView.isHidden = false
            
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
            progressType = .default
            loadingProgressView.isHidden = true
            
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
    
    public func loadImageFromCache(forURL requestURL: URL) -> UIImage? {
        
        if let cachedImage = NFImageCacheAPI.shared.imageContentInCacheStorage(forURL: requestURL) {
            
            // update cache for url request
            NFImageCacheAPI.shared.downloadQueue.async(execute: {
                let _ = NFImageCacheAPI.shared.download(imageURL: requestURL)
            })
            
            return cachedImage
        }
        
        return nil
    }
    
    /**
     * Set image from image URL string
     */
    public func setImage(fromURLString URLString: String, placeholder: UIImage? = nil, completion: NFImageViewRequestCompletion? = nil) {
        cancelReceipt() // cancel receipt
        
        if !URLString.isEmpty, let imageURL = URL(string: URLString) {
            imageActiveURL = imageURL // save active image url
            
            if let cachedImage = loadImageFromCache(forURL: imageURL) {
                image = cachedImage
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
            progressType = .default
            loadImage(fromURL: imageURL, completion: completion)
        }else{
            forceStartLoadingState()
            
            switch loadingType {
            case .progress:
                
                progressType = .image
                loadWithProgress(imageURL: imageURL) { [unowned self] (code, error) in
                    
                    if code == .canceled { // if canceled or new image request has been placed
                        // reload from last active image url
                        self.setImage(fromURL: self.imageActiveURL, placeholder: placeholder, completion: completion)
                    }else{
                        self.forceStopLoadingState()
                        completion?(code, error)
                    }
                }
                
            case .spinner:
                
                loadWithSpinner(imageURL: imageURL) { [unowned self] (code, error) in
                    
                    if code == .canceled { // if canceled or new image request has been placed
                        // reload from last active image url
                        self.setImage(fromURL: self.imageActiveURL, placeholder: placeholder, completion: completion)
                    }else{
                        self.forceStopLoadingState()
                        completion?(code, error)
                    }
                }
            }
        }
    }
    
    /**
     * Set thumbnail and large image from URL sting with blur effect transition
     */
    public func setThumbImageAndLargeImage(fromURLString thumbURLString: String, largeURLString: String, placeholder: UIImage? = nil, completion: NFImageViewRequestCompletion? = nil) {
        cancelReceipt() // cancel receipt
        
        if !thumbURLString.isEmpty && !largeURLString.isEmpty, let thumbURL = URL(string: thumbURLString), let imageURL = URL(string: largeURLString) {
            
            thumbActiveURL = thumbURL // save active image url
            imageActiveURL = imageURL // save active image url
            
            if let cachedImage = loadImageFromCache(forURL: imageURL) {
                image = cachedImage
                completion?(.success, nil)
            }else{
                setThumbImageAndLargeImage(fromURL: thumbURL, largeURL: imageURL, placeholder: placeholder, completion: completion)
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
            progressType = .default
            loadImage(fromURL: thumbURL, completion: { [unowned self] (code, error) in
                
                if code == .canceled { // if canceled or new image request has been placed
                    // reload from last active thumb url
                    self.setThumbImageAndLargeImage(fromURL: self.thumbActiveURL, largeURL: self.imageActiveURL, placeholder: placeholder, completion: completion)
                }else{
                    self.loadImage(fromURL: largeURL, completion: { (code, error) in
                        
                        if code == .canceled { // if canceled or new image request has been placed
                            // reload from last active image url
                            self.setThumbImageAndLargeImage(fromURL: self.thumbActiveURL, largeURL: self.imageActiveURL, placeholder: placeholder, completion: completion)
                        }else{
                            completion?(code, error)
                        }
                    })
                }
            })
        }else{
            forceStartLoadingState(isBlurEnabled: true)
            
            switch loadingType {
            case .progress:
                
                progressType = .thumbnail
                loadWithProgress(imageURL: thumbURL, completion: { [unowned self] (code, error) in
                    
                    if code == .canceled { // if canceled or new image request has been placed
                        // reload from last active thumb url
                        self.progressType = .thumbnail
                        self.setThumbImageAndLargeImage(fromURL: self.thumbActiveURL, largeURL: self.imageActiveURL, placeholder: placeholder, completion: completion)
                        
                    }else{
                        self.progressType = .still
                        self.loadWithProgress(imageURL: largeURL, completion: { [unowned self] (code, error) in
                            
                            if code == .canceled { // if canceled or new image request has been placed
                                // reload from last active image url
                                self.setThumbImageAndLargeImage(fromURL: self.thumbActiveURL, largeURL: self.imageActiveURL, placeholder: placeholder, completion: completion)
                            }else{
                                self.forceStopLoadingState()
                                completion?(code, error)
                            }
                        })
                    }
                })
                
            case .spinner:
                
                loadWithSpinner(imageURL: thumbURL, completion: { [unowned self] (code, error) in
                    
                    if code == .canceled { // if canceled or new image request has been placed
                        // reload from last active thumb url
                        self.progressType = .thumbnail
                        self.setThumbImageAndLargeImage(fromURL: self.thumbActiveURL, largeURL: self.imageActiveURL, placeholder: placeholder, completion: completion)
                        
                    }else{
                        self.loadWithSpinner(imageURL: largeURL, completion: { [unowned self] (code, error) in
                            
                            if code == .canceled { // if canceled or new image request has been placed
                                // reload from last active image url
                                self.setThumbImageAndLargeImage(fromURL: self.thumbActiveURL, largeURL: self.imageActiveURL, placeholder: placeholder, completion: completion)
                            }else{
                                self.forceStopLoadingState()
                                completion?(code, error)
                            }
                        })
                    }
                })
            }
        }
    }
}
