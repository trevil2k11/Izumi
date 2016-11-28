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
    
    @IBOutlet weak var loadImage: UIImageView!
    @IBOutlet weak var userRating: UILabel!
    @IBOutlet weak var stylistRating: UILabel!
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var commentView: UITextView!
    
    @IBOutlet weak var hiddenCommentView: UIView!
    @IBOutlet weak var hiddenHideComment: UIButton!
    @IBOutlet weak var hiddenCommentText: UITextField!
    @IBOutlet weak var hiddenCommentSend: UIButton!
    @IBOutlet weak var hiddenRating: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(_ dict: [String:String]) {
        let imgUrl = jsonLib.returnFullURL(dict["pic_data"]!)
        self.pic_id = Int(dict["id"]!)!
        ImageLoader.sharedLoader.imageForUrl(imgUrl) { (image, url) -> () in
            self.loadImage.image = image;
            self.activityIndicator.stopAnimating();
        }
        
        self.imageName.text = dict["pic_name"]
        self.userRating.text = dict["avg_user_rate"]?.isEmpty == true ? "0" : dict["avg_user_rate"];
        self.stylistRating.text = dict["avg_stylist_rate"]?.isEmpty == true ? "0" : dict["avg_stylist_rate"];
        getComment(dict["id"]!)
    }
    
    func getComment(_ id: String) {
        let body: String = self.jsonLib.returnComments(id)
        curlSender.sendData(body) {result in
            self.libComment = self.helperLib.returnDictFromJSON(result!)
            self.addComment()
        }
    }
    
    func addComment() {
        if self.libComment.count > 0 {
            let finMutStr = NSMutableAttributedString()
            let paragraphStyleBold = NSMutableParagraphStyle()
            paragraphStyleBold.alignment = NSTextAlignment.left
            let paragraphStyleStd = NSMutableParagraphStyle()
            paragraphStyleStd.alignment = NSTextAlignment.justified
            
            let attrsBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
                             NSParagraphStyleAttributeName: paragraphStyleBold]
            let attrsStd = [NSParagraphStyleAttributeName: paragraphStyleStd]
            
            for obj in self.libComment {
                let header = NSMutableAttributedString(string: obj["header"]! + "\n", attributes: attrsBold)
                header.append(NSAttributedString(string: obj["user_comment"]! + "\n", attributes: attrsStd))
                finMutStr.append(header);
            }
            OperationQueue.main.addOperation {
                self.commentView.attributedText = finMutStr.mutableCopy() as! NSAttributedString
            }
        }
    }
}
