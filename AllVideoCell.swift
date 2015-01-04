//
//  AllVideoCellTableViewCell.swift
//  WatchSnowboarding
//
//  Created by Takahiro Masaki on 2015/01/04.
//  Copyright (c) 2015年 Takahiro Masaki. All rights reserved.
//

import UIKit

class AllVideoCell: UITableViewCell {

    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoDuration: UILabel!
    @IBOutlet weak var videoPublished: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
