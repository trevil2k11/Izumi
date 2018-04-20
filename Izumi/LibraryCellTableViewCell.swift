//
//  LibraryCellTableViewCell.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 30.04.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import UIKit

class LibraryCellTableViewCell: UITableViewCell {

    let curlSender = CurlController()
    let helperLib = Helper()
    let jsonLib = LibraryJSON();
    
    var libComment: [[String:String]] = []
    var pic_id: Int = 0;
    
    @IBOutlet weak var autorAvatar: UIImageView!
    @IBOutlet weak var loadImage: UIImageView!
    @IBOutlet weak var viewForPhoto: UIView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var goToComments: UIButton!
    @IBOutlet weak var starIt: UIButton!
    @IBOutlet weak var uploader_nickname: UILabel!
    
    @IBOutlet weak var commentView: UITextView!
    
    let paragraphStyleBold = NSMutableParagraphStyle()
    let paragraphStyleStd = NSMutableParagraphStyle()
    
    var attrsBold: [String: Any] = [:]
    var attrsStd: [String: Any] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        paragraphStyleBold.alignment = NSTextAlignment.left
        paragraphStyleStd.alignment = NSTextAlignment.justified
        
        helperLib.doRound(autorAvatar)
        autorAvatar.backgroundColor = .gray
        
        attrsBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSParagraphStyleAttributeName: paragraphStyleBold]
        attrsStd = [NSParagraphStyleAttributeName: paragraphStyleStd]
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var photoHeight: NSLayoutConstraint!
    
    func configure(_ dict: [String:Any]) {
        self.pic_id = Int(dict["pic_id"] as! String)!
        self.uploader_nickname.text = dict["author"] as? String
        activityIndicator.stopAnimating()
        self.loadImage.image = dict["image"] as? UIImage
        addComment(dict)
    }

    func addComment(_ dict : [String:Any]) {
        let finalMutableString = NSMutableAttributedString()
            let header = NSMutableAttributedString(string: dict["comment_author"] as! String + " - ", attributes: attrsBold)
            header.append(NSAttributedString(string: dict["comment"] as! String, attributes: attrsStd))
            finalMutableString.append(header);
    
            self.commentView.attributedText = finalMutableString.mutableCopy() as! NSAttributedString
    }
}
