//
//  GCDLoader.swift
//  WatchSnowboarding
//
//  Created by Takahiro Masaki on 2015/01/10.
//  Copyright (c) 2015年 Takahiro Masaki. All rights reserved.
//

import Foundation
import UIKit

public class GCDLoader {
    
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    func dispatch_async_global(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }
}