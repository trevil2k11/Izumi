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
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var goToComments: UIButton!
    @IBOutlet weak var starIt: UIButton!
    
    @IBOutlet weak var commentView: UITextView!
    
    let paragraphStyleBold = NSMutableParagraphStyle()
    let paragraphStyleStd = NSMutableParagraphStyle()
    
    var attrsBold: [String: Any] = [:]
    var attrsStd: [String: Any] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        paragraphStyleBold.alignment = NSTextAlignment.left
        paragraphStyleStd.alignment = NSTextAlignment.justified
        
        attrsBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSParagraphStyleAttributeName: paragraphStyleBold]
        attrsStd = [NSParagraphStyleAttributeName: paragraphStyleStd]
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
            if self.libComment.count > 1 {
                let header = NSMutableAttributedString(string: self.libComment[0]["header"]! + "\n", attributes: attrsBold)
                header.append(NSAttributedString(string: self.libComment[0]["user_comment"]! + "\n", attributes: attrsStd))
                header.append(NSAttributedString(string: ".......(" + String(self.libComment.count) + ")\n", attributes: attrsStd))
                finMutStr.append(header)
            } else if self.libComment.count == 1 {
                let header = NSMutableAttributedString(string: self.libComment[0]["header"]! + "\n", attributes: attrsBold)
                header.append(NSAttributedString(string: self.libComment[0]["user_comment"]! + "\n", attributes: attrsStd))
                finMutStr.append(header);
            }
            OperationQueue.main.addOperation {
                self.commentView.attributedText = finMutStr.mutableCopy() as! NSAttributedString
                self.rating.text = String(self.libComment.count)
            }
        }
    }
}
