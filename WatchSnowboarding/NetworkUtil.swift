//
//  NetworkUtil.swift
//  WatchSnowboarding
//
//  Created by Takahiro Masaki on 2015/01/03.
//  Copyright (c) 2015年 Takahiro Masaki. All rights reserved.
//

import Foundation

class NetworkUtil: NSObject {
    
    class func hasConnectity() -> Bool {
        let reachability : Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus : Int = reachability.currentReachabilityStatus().value
        return networkStatus != 0
    }
    
}