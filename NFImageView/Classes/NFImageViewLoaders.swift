//
//  NFImageViewLoaders.swift
//  NFImageView
//
//  Created by Neil Francis Hipona on 2/24/20.
//

import Foundation
import Alamofire
import AlamofireImage

// MARK: - DataRequest

extension DataRequest {
    
    /// Return request's URL in DataRequest
    var url: URL? {
        request?.url
    }
}

// MARK: - RequestReceipt

extension RequestReceipt {
    
    /// Cancel the current URL request in the RequestReceipt
    func cancel() {
        request.cancel()
    }
}

// MARK: - Loaders

extension NFImageView {
    
    internal func loadWithSpinner(imageURL: URL, completion: NFImageViewRequestCompletion? = nil) {
        if let receipt = requestReceipt {
            receipt.cancel()
            
            if let canceledURL = receipt.request.url {
                NFImageCacheAPI.shared.downloadQueue.async(execute: {
                    let _ = NFImageCacheAPI.shared.download(imageURL: canceledURL)
                })
            }
            requestReceipt = nil
        }
        
        forceStartLoadingState()
        
        requestReceipt = NFImageCacheAPI.shared.download(imageURL: imageURL, completion: { (response) in
            
            switch response.result {
                
            case .success(let value):
                self.forceStopLoadingState()
                
                self.image = value
                completion?(.success, nil)
                
            case .failure(let error):
                if let errorCode = response.response?.statusCode, errorCode != NFImageViewRequestCode.canceled.rawValue {
                    self.forceStopLoadingState()
                    completion?(.unknown, error as NSError?)
                }else{
                    completion?(.canceled, error as NSError?)
                }
            }
        })
    }
    
    internal func loadWithProgress(imageURL: URL, shouldContinueLoading: Bool = false, completion: NFImageViewRequestCompletion? = nil) {
        if let receipt = requestReceipt {
            receipt.cancel()
            
            if let canceledURL = receipt.request.url {
                NFImageCacheAPI.shared.downloadQueue.async(execute: {
                    let _ = NFImageCacheAPI.shared.download(imageURL: canceledURL)
                })
            }
            requestReceipt = nil
        }
        
        forceStartLoadingState()
        
        requestReceipt = NFImageCacheAPI.shared.downloadWithProgress(imageURL: imageURL, progress: { (progress) in
            
            self.loadingProgressView.setProgress(Float(progress.fractionCompleted), animated: true)
            
        }) { (response) in
            
            switch response.result {
                
            case .success(let value):
                if !shouldContinueLoading {
                    self.forceStopLoadingState()
                }
                
                self.image = value
                completion?(.success, nil)
                
            case .failure(let error):
                if let errorCode = response.response?.statusCode, errorCode != NFImageViewRequestCode.canceled.rawValue {
                    if !shouldContinueLoading {
                        self.forceStopLoadingState()
                    }
                    
                    completion?(.unknown, error as NSError?)
                }else{
                    completion?(.canceled, error as NSError?)
                }
            }
        }
    }
    
    /**
     * Use when loading is disabled
     */
    internal func loadImage(fromURL imageURL: URL, completion: NFImageViewRequestCompletion? = nil) {
        if let receipt = requestReceipt {
            receipt.cancel()
            
            if let canceledURL = receipt.request.url {
                NFImageCacheAPI.shared.downloadQueue.async(execute: {
                    let _ = NFImageCacheAPI.shared.download(imageURL: canceledURL)
                })
            }
            requestReceipt = nil
        }
        
        requestReceipt = NFImageCacheAPI.shared.download(imageURL: imageURL, completion: { (response) in
            
            switch response.result {
                
            case .success(let value):
                self.image = value
                completion?(.success, nil)
                
            case .failure(let error):
                if let errorCode = response.response?.statusCode, errorCode != NFImageViewRequestCode.canceled.rawValue {
                    completion?(.unknown, error as NSError?)
                }else{
                    completion?(.canceled, error as NSError?)
                }
            }
        })
    }
}
