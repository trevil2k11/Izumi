//
//  PortfolioCell.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 20.07.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//
import UIKit

class PortfolioCell: UICollectionViewCell {
    
    let helperLib = Helper();
    let jsonLib = LibraryJSON();
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    @IBOutlet weak var avg_stl: UILabel!
    
    func onLoadAnimation(_ dict: [String:String]) {
        let imgUrl = jsonLib.returnFullURL(dict["pic_data"]!)
        ImageLoader.sharedLoader.imageForUrl(imgUrl) { (image, url) -> () in
            self.imgView.image = image
            self.avg_stl.text = dict["avg_sylist_rate"]
            self.actInd.stopAnimating();
        }
    }
}
