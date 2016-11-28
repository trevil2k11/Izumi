//
//  FavoritesCell.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 30.06.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import UIKit

class FavoritesCell: UICollectionViewCell {
    
    let helperLib = Helper();
    let jsonLib = LibraryJSON();
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    @IBOutlet weak var avg_usr: UILabel!
    @IBOutlet weak var avg_stl: UILabel!
    
    func onLoadAnimation(_ dict: [String:String]) {
        let imgUrl = jsonLib.returnFullURL(dict["pic_data"]!)
        ImageLoader.sharedLoader.imageForUrl(imgUrl) { (image, url) -> () in
            self.imgView.image = image == nil ? nil : image
            self.avg_usr.text = dict["avg_usr_rate"]
            self.avg_stl.text = dict["avg_sylist_rate"]
            self.actInd.stopAnimating();
        }
    }
}
