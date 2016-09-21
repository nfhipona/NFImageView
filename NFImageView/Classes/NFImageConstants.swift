//
//  NFImageConstants.swift
//  Pods
//
//  Created by Neil Francis Hipona on 23/07/2016.
//  Copyright (c) 2016 Neil Francis Ramirez Hipona. All rights reserved.
//

import Foundation

public enum NFImageViewLoadingType: Int {
    
    case `default`
    case spinner
    case progress
}

public enum NFImageViewRequestCode: Int {
    
    case unknown
    case success = 4776
    case canceled = -999
    
}

public typealias NFImageViewRequestCompletion = (_ code: NFImageViewRequestCode, _ error: NSError?) -> Void


public enum ViewContentMode: Int {
    
    case fill // will fill the entire bounds
    case aspectFit // contents scaled to fit with fixed aspect. remainder is transparent
    case aspectFill // contents scaled to fill with fixed aspect. some portion of content may be clipped.
    case originalSize // image size is retained
}

public struct ViewContentFill: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    
    /// The option to align the content to the center.
    public static let Center = ViewContentFill(rawValue: 0)
    /// The option to align the content to the left.
    public static let Left = ViewContentFill(rawValue: 1)
    /// The option to align the content to the right.
    public static let Right = ViewContentFill(rawValue: 2)
    /// The option to align the content to the top.
    public static let Top = ViewContentFill(rawValue: 4)
    /// The option to align the content to the bottom.
    public static let Bottom = ViewContentFill(rawValue: 8)
    /// The option to align the content to the top left.
    public static let TopLeft: ViewContentFill = [Top, Left]
    /// The option to align the content to the top right.
    public static let TopRight: ViewContentFill = [Top, Right]
    /// The option to align the content to the bottom left.
    public static let BottomLeft: ViewContentFill = [Bottom, Left]
    /// The option to align the content to the bottom right.
    public static let BottomRight: ViewContentFill = [Bottom, Right]
}
