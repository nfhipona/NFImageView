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
