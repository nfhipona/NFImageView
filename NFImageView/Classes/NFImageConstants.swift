//
//  NFImageConstants.swift
//  Pods
//
//  Created by Neil Francis Hipona on 23/07/2016.
//  Copyright (c) 2016 Neil Francis Ramirez Hipona. All rights reserved.
//

import Foundation

public enum NFImageViewLoadingType: Int {
    
    case Default
    case Spinner
    case Progress
}

public enum NFImageViewRequestCode: Int {
    
    case Unknown
    case Success = 4776
    case Canceled = -999
    
}

public typealias NFImageViewRequestCompletion = (code: NFImageViewRequestCode, error: NSError?) -> Void


public enum ViewContentMode: Int {
    
    case Fill // will fill the entire bounds
    case AspectFit // contents scaled to fit with fixed aspect. remainder is transparent
    case AspectFill // contents scaled to fill with fixed aspect. some portion of content may be clipped.
    case OriginalSize // image size is retained
}

public struct ViewContentFill: OptionSetType {
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
