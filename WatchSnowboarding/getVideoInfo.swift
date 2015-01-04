//
//  Movie.swift
//  WatchSnowboarding
//
//  Created by Takahiro Masaki on 2015/01/03.
//  Copyright (c) 2015年 Takahiro Masaki. All rights reserved.
//

import Foundation
import UIKit

public class VideoItem : NSObject {
    var videoId: String
    var myKey: String = "AIzaSyDmNQZCxeEemsIs_ZvFcsPOJUHxMbb_IN0"
    var title: String
    var time: String
    var published_at: String
    var imageUrl: String
    
    init(videoId: String, title: String, time: String, published_at: String, imageUrl: String) {
        self.videoId = videoId
        self.title = title
        self.time = time
        self.published_at = published_at
        self.imageUrl = imageUrl
    }
}