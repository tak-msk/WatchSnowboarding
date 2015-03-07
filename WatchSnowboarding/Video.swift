//
//  SampleData.swift
//  WatchSnowboarding
//
//  Created by Takahiro Masaki on 2015/01/03.
//  Copyright (c) 2015年 Takahiro Masaki. All rights reserved.
//

import Foundation
import UIKit

class Video {
    
    // GMT+9 = JST
    let timeInterval:NSTimeInterval = 32400
    // Get Google API Key for getting youtube video api - v3
    var myKey:String = "AIzaSyDObTxjsbpjfmw0SvGr25n-rtRF_DdyCSM" //NSProcessInfo.processInfo().environment["ENV_GGL_KEY"] as String
    // nextPageToken on Youtube
    var nextPageToken:String = ""
    
    func getYoutubeVideoList(keyword: String, maxResults: Int) -> Array<Dictionary<String, AnyObject>> {
        
        var videoList = [Dictionary<String, AnyObject>]()
        
        if NetworkUtil.hasConnectity() {
            let baseApiUrl:String = "https://www.googleapis.com/youtube/v3/search?part=snippet&q="
            var apiUrl:String = baseApiUrl + keyword + "&maxResults=" + String(maxResults) + "&order=date&videoEmbeddable=true&videoSyndicated=true&type=video&key=" + myKey
            
            if self.nextPageToken != "" {
                apiUrl = apiUrl + "&pageToken=" + self.nextPageToken
            }

            let listJson = jsonFromUrl(apiUrl)
            
            // add nextPageToken if there is
            if listJson["nextPageToken"].stringValue != "" {
                self.nextPageToken = listJson["nextPageToken"].stringValue
            } else {
                self.nextPageToken = ""
            }
            
            for var i=0; i<maxResults; i++ {
                var video: Dictionary<String, AnyObject>! = Dictionary<String, AnyObject!>()
                
                // videoId
                let videoId:String = listJson["items"][i]["id"]["videoId"].stringValue as String
                video["id"] = videoId
                
                // title
                let title:String = listJson["items"][i]["snippet"]["title"].stringValue as String
                video["title"] = title
                
                // duration
                var videoInfo:Dictionary<String, AnyObject> = getYoutubeVideoContentDetail(videoId)
                video["duration"] = videoInfo["duration"]
                
                // published at
                let dateFormatterYT = NSDateFormatter()
                dateFormatterYT.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dateString = listJson["items"][i]["snippet"]["publishedAt"].stringValue
                let publishedDate = dateFormatterYT.dateFromString(dateString)!
                video["publishedAt"] = dateFormatter.stringFromDate(NSDate(timeInterval: timeInterval, sinceDate: publishedDate))
                
                // thumbnail image
                let imageUrl:String = listJson["items"][i]["snippet"]["thumbnails"]["high"]["url"].stringValue as String
                let urlReq = NSURLRequest(URL:NSURL(string: imageUrl)!)
                video["imageUrlRequest"] = urlReq
                
                // optional binding
                if let videoTitle = video["title"] as? String {
                    videoList.append(video)
                } else {
                    println("faild")
                }
            }
        }
        return videoList
    }
    
    func getYoutubeVideoContentDetail(id: String) -> Dictionary<String, AnyObject> {
        var videoInfo = Dictionary<String, AnyObject>()
        
        let baseUrl:String = "https://www.googleapis.com/youtube/v3/videos?id="
        var apiUrl:String = baseUrl + id + "&key=" + myKey + "&fields=items(id,contentDetails)&part=contentDetails"
        
        var infoJson = jsonFromUrl(apiUrl)
        
        if infoJson["items"].isEmpty != true {
            // contentDetails->definition
            let videoDefinition:String = infoJson["items"][0]["contentDetails"]["definition"].stringValue
            videoInfo["definition"] = videoDefinition
            
            // contentDetails->licensedContent
            let videoLicensed:String = infoJson["items"][0]["contentDetails"]["licensedContent"].stringValue
            videoInfo["licensedContent"] = videoLicensed
            
            // contentDetails->duration
            // prepare for converting from string to date
            let dateFormatterYT = NSDateFormatter()
            dateFormatterYT.dateFormat = "'PT'HH'H'mm'M'ss'S'"
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            
            var videoDuration:String = infoJson["items"][0]["contentDetails"]["duration"].stringValue
            
            videoDuration = adjustFormat(videoDuration)
            
            // convert and insert
            videoInfo["duration"] = dateFormatter.stringFromDate(dateFormatterYT.dateFromString(videoDuration)!)
            
            // contentDetails->dimension
            let videoDimension:String = infoJson["items"][0]["contentDetails"]["dimension"].stringValue
            videoInfo["dimension"] = videoDimension
            
            // contentDetails->caption
            let videoCaption:String = infoJson["items"][0]["contentDetails"]["caption"].stringValue
            videoInfo["caption"] = videoCaption
        }
        return videoInfo
    }
    
    // create json file from api's url
    func jsonFromUrl(apiUrl: String) -> JSON {
        var requestUrl:NSURL = NSURL(string: apiUrl)!
        var request:NSURLRequest = NSURLRequest(URL: requestUrl)

        // request to api
        var data:NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: NSErrorPointer())!
        
        // read json response
        let json = JSON(data: data)
        
        return json
    }
    
    // adjust dateFormat
    func adjustFormat(var time:String) -> String {
        // adjust to HH
        if time.rangeOfString("H") == nil {
            var idx1:String.Index = advance(time.startIndex, 2)
            var beforeStrHH:String = time.substringToIndex(idx1)
            
            var idx2:String.Index = advance(time.startIndex, 2)
            var afterStrHH:String = time.substringFromIndex(idx2)
            
            time = beforeStrHH + "00H" + afterStrHH
        }
        
        // adjust to mm
        if time.rangeOfString("M") == nil {
            var idx3:String.Index = advance(time.startIndex, 5)
            var beforeStrMM:String = time.substringToIndex(idx3)
            
            var idx4:String.Index = advance(time.startIndex, 5)
            var afterStrMM:String = time.substringFromIndex(idx4)
            
            time = beforeStrMM + "0M" + afterStrMM
        }
        
        // adjust to ss
        if time.rangeOfString("S") == nil {
            
            time = time + "0S"
        }

        return time
    }
}