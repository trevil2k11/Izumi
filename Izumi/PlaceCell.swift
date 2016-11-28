//
//  CommentCell.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 30.04.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func configure(_ dict:[String:String]) {
        self.headerLabel.text = dict["description"]
    }

}
