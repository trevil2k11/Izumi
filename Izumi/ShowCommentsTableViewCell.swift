//
//  ShowCommentsTableViewCell.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 13.03.2018.
//  Copyright © 2018 Ilya Kosolapov. All rights reserved.
//

import UIKit

class ShowCommentsTableViewCell: UITableViewCell {
    
    var userId: Int = 0;
    var isLiked: Bool = false;
    @IBOutlet weak var likeCommentBtn: UIButton!
    @IBOutlet weak var textArea: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
