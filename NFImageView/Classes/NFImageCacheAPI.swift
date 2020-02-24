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
    
    public static let shared = NFImageCacheAPI()
    
    public lazy var imageDownloadQueue: DispatchQueue = {
        DispatchQueue(label: "com.NFImageDownloadQueue.concurrent", attributes: DispatchQueue.Attributes.concurrent)
    }()
    
    fileprivate let imageRequestCache: AutoPurgingImageCache = {
        AutoPurgingImageCache(memoryCapacity: 150 * 1024 * 1024, preferredMemoryUsageAfterPurge: 60 * 1024 * 1024)
    }()

    fileprivate lazy var imageDownloader: ImageDownloader = {
        ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(), downloadPrioritization: .lifo, maximumActiveDownloads: 4, imageCache: self.imageRequestCache)
    }()
    
    // MARK: - Public Functions
    
    /**
     * Asynchronously download and cache image from a requested URL using AlamofireImage configuration
     */
    public func download(imageURL requestURL: URL, completion: ImageDownloader.CompletionHandler? = nil) -> RequestReceipt? {
        let request = URLRequest(url: requestURL)
        
        return imageDownloader.download(request, completion: completion)
    }
    
    /**
     * Asynchronously download and cache image from a requested URL using AlamofireImage configuration with progress handler
     */
    public func downloadWithProgress(imageURL requestURL: URL, progress: ImageDownloader.ProgressHandler?, completion: ImageDownloader.CompletionHandler?) -> RequestReceipt? {
        let request = URLRequest(url: requestURL)
        
        return imageDownloader.download(request, progress: progress, completion: completion)
    }
    
    /**
     * Check image cache for url request
     */
    public func imageContentInCacheStorage(forURL requestURL: URL, identifier: String? = nil) -> UIImage? {
        
        let request = URLRequest(url: requestURL)
        return imageRequestCache.image(for: request, withIdentifier: identifier)
    }
    
    /**
     * Cache image for url request
     */
    public func cacheImage(_ image: UIImage, forURL requestURL: URL, identifier: String? = nil) {
        
        let request = URLRequest(url: requestURL)
        imageRequestCache.add(image, for: request, withIdentifier: identifier)
    }
    
    /**
     * Remove image from cache for url request
     */
    public func removeCachedImage(forURL requestURL: URL, identifier: String? = nil) {
        
        let request = URLRequest(url: requestURL)
        imageRequestCache.removeImage(for: request, withIdentifier: identifier)
    }
}
