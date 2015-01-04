//
//  YoutubeLoader.swift
//  WatchSnowboarding
//
//  Created by Takahiro Masaki on 2015/01/04.
//  Copyright (c) 2015年 Takahiro Masaki. All rights reserved.
//

import UIKit

extension UIWebView {
    
    func loadYoutubeWithVideoID(videoID:String) {
        
        self.scrollView.scrollEnabled = false
        self.scrollView.bounces = false
        
        
        var htmlString:String = "<!DOCTYPE html><head><meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no, width=\"\(self.frame.width)\"></head><body style=\"background:#000000; margin-top:0px; margin-left:0px\"><iframe width=\"\(self.frame.width)\" height=\"\(self.frame.height)\" src=\"https://www.youtube.com/embed/\(videoID)?showinfo=0\" frameborder=\"0\" allowfullscreen></iframe></body></html>"
        
        println(htmlString)
        
        self.loadHTMLString(htmlString, baseURL: nil)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
