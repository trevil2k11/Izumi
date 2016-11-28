//
//  WardrobeCell.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 07.06.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import UIKit

class WardrobeCell: UICollectionViewCell {
    
    let helperLib = Helper();
    let jsonLib = LibraryJSON();
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    
    func onLoadAnimation(_ url: String) {
        let imgUrl = jsonLib.returnFullURL(url)
        ImageLoader.sharedLoader.imageForUrl(imgUrl) { (image, url) -> () in
            self.imgView.image = image
            self.actInd.stopAnimating();
        }
    }
}
