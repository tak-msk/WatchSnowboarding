//
//  AllBoaderCell.swift
//  
//
//  Created by Takahiro Masaki on 2015/01/11.
//
//

import UIKit

class AllBoaderCell: UITableViewCell {

    @IBOutlet weak var boaderImage: UIImageView!
    @IBOutlet weak var boaderName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
