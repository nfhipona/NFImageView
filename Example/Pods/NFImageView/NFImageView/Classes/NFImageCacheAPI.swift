//
//  NFImageCacheAPI.swift
//  Pods
//
//  Created by Neil Francis Hipona on 23/07/2016.
//  Copyright (c) 2016 Neil Francis Ramirez Hipona. All rights reserved.
//

import Foundation
import AlamofireImage
import Alamofire

public class NFImageCacheAPI: NSObject {
    
    public static let sharedAPI = NFImageCacheAPI()
    
    public lazy var imageDownloadQueue: dispatch_queue_t = {
        dispatch_queue_create("com.NFImageDownloadQueue.concurrent", DISPATCH_QUEUE_CONCURRENT)
    }()
    
    private let imageRequestCache: AutoPurgingImageCache = {
        AutoPurgingImageCache(memoryCapacity: 150 * 1024 * 1024, preferredMemoryUsageAfterPurge: 60 * 1024 * 1024)
    }()
    
    private lazy var imageDownloader: ImageDownloader = {
        ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(), downloadPrioritization: .LIFO, maximumActiveDownloads: 4, imageCache: self.imageRequestCache)
    }()
    
    // MARK: - Public Functions
    
    /**
     * Asynchronously download and cache image from a requested URL using AlamofireImage configuration
     */
    public func downloadImage(requestURL: NSURL, completion: ImageDownloader.CompletionHandler? = nil) -> RequestReceipt? {
        let request = NSURLRequest(URL: requestURL)
        
        return imageDownloader.downloadImage(URLRequest: request, completion: completion)
    }
    
    /**
     * Asynchronously download and cache image from a requested URL using AlamofireImage configuration with progress handler
     */
    public func downloadImageWithProgress(requestURL: NSURL, progress: ImageDownloader.ProgressHandler?, completion: ImageDownloader.CompletionHandler?) -> RequestReceipt? {
        let request = NSURLRequest(URL: requestURL)
        
        return imageDownloader.downloadImage(URLRequest: request, progress: progress, completion: completion)
    }
    
    /**
     * Check image cache for url request
     */
    public func checkForImageContentInCacheStorage(requestURL: NSURL, identifier: String? = nil) -> UIImage? {
        
        let request = NSURLRequest(URL: requestURL)
        return imageRequestCache.imageForRequest(request, withAdditionalIdentifier: identifier)
    }
    
    /**
     * Cache image for url request
     */
    public func cacheImageForRequestURL(image: UIImage, requestURL: NSURL, identifier: String? = nil) {
        
        let request = NSURLRequest(URL: requestURL)
        imageRequestCache.addImage(image, forRequest: request, withAdditionalIdentifier: identifier)
    }
    
    /**
     * Remove image from cache for url request
     */
    public func removeCachedImageForRequestURL(requestURL: NSURL, identifier: String? = nil) {
        
        let request = NSURLRequest(URL: requestURL)
        imageRequestCache.removeImageForRequest(request, withAdditionalIdentifier: identifier)
    }
}