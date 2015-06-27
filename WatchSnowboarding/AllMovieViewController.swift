//
//  AllMovieViewController.swift
//  WatchSnowboarding
//
//  Created by Takahiro Masaki on 2015/01/03.
//  Copyright (c) 2015年 Takahiro Masaki. All rights reserved.
//

import UIKit
import SVProgressHUD

class AllMovieViewController: UITableViewController {
    
    @IBAction func closeVideoScene(segue:UIStoryboardSegue) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var video = Video()
    var videos = [Dictionary<String, AnyObject>]()
    
    var selectedVideoID:String? = nil
    var selectedVideoIndex:Int? = nil
    
    // Load GCD(Grand Central Dispatch) as a background process
    var gcd = GCDLoader()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar

        nav?.tintColor = UIColor.whiteColor()
        nav?.barTintColor = UIColor(red: 0, green: 0.75, blue: 1.0, alpha: 1.0)
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        videos = video.getYoutubeVideoList("Snowboarding", maxResults: 10)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return videos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell", forIndexPath: indexPath) as! AllVideoCell

        if let videoTitle = videos[indexPath.row]["title"] as? NSString {
            cell.videoTitle.text = videoTitle as String
        }
        
        if let videoDuration = videos[indexPath.row]["duration"] as? NSString {
            cell.videoDuration.text = videoDuration as String
        } else {
            cell.videoDuration.text = "Private Video"
        }
        
        if let videoPublished = videos[indexPath.row]["publishedAt"] as? NSString {
            cell.videoPublished.text = videoPublished as String
        }
        
        // AsynchronousRequest for thumbnail images
        var imageReq:NSURLRequest = videos[indexPath.row]["imageUrlRequest"] as! NSURLRequest
        NSURLConnection.sendAsynchronousRequest(imageReq, queue:NSOperationQueue.mainQueue()){(res, data, err) in
            let image = UIImage(data:data)
            cell.videoImage.image = image
        }
        
        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        println("check1 : Work didselected")
//        selectedVideoIndex = indexPath.row
//        selectedVideoID = videos[indexPath.row]["id"] as NSString
//        
//        println(selectedVideoID)
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.bounds.size.height {
            // From SVProgressHUD Pods
            SVProgressHUD.setBackgroundColor(UIColor.whiteColor().colorWithAlphaComponent(0.9))
            SVProgressHUD.showWithStatus("Loading")
            gcd.dispatch_async_main {
                // add 10 videos more
                self.videos += self.video.getYoutubeVideoList("Snowboarding", maxResults: 10)
                SVProgressHUD.dismiss()
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "SelectVideo" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            selectedVideoIndex = indexPath?.row
            if let index = selectedVideoIndex {
                selectedVideoID = videos[index]["id"] as! NSString as String
            }
            
            /* refer this http://stackoverflow.com/questions/24554361/swift-exc-breakpoint-when-assigning-viewcontroller-to-variable-in-prepareforsegu
            */
            let videoNavigationController = segue.destinationViewController as! UINavigationController
            let videoPickerViewController = videoNavigationController.viewControllers[0] as! VideoViewController
            videoPickerViewController.selectedVideoID = selectedVideoID
        }
    }

}
