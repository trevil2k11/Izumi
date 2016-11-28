//
//  UserProfileFigure.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 02.07.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import UIKit

class UserProfileFigure: UIViewController {
    let helperLib = Helper();
    let curlSender = CurlController();
    let LibJSON = LibraryJSON();
    
    @IBOutlet weak var fullPict: UIImageView!
    @IBOutlet weak var upperBody: UIImageView!
    @IBOutlet weak var midUp: UIImageView!
    @IBOutlet weak var midBott: UIImageView!
    @IBOutlet weak var bottomBody: UIImageView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let data = LibJSON.returnUserDetails(helperLib.loadUserDefaults("user_id"));
        curlSender.sendData(data) { (result) in
            OperationQueue.main.addOperation {
                let dict: [String:String] = self.helperLib.returnDictFromJSON(result!)[0]
                
                ImageLoader.sharedLoader.imageForUrl(self.LibJSON.returnFullURL(dict["pic_data"]!), completionHandler: { (image, url) in
                    self.loadIndicator.stopAnimating();
                    self.fullPict.image = self.helperLib.compressImage(image!, maxHeight: self.fullPict.bounds.height, maxWidth: self.fullPict.bounds.width)
                })
                
                let libBody = self.helperLib.returnFullBody();
                
                self.upperBody.image = UIImage(named: libBody[0][Int(dict["type_up"]!)!])
                self.midUp.image = UIImage(named: libBody[1][Int(dict["type_mid_up"]!)!])
                self.midBott.image = UIImage(named: libBody[2][Int(dict["type_mid_down"]!)!])
                self.bottomBody.image = UIImage(named: libBody[3][Int(dict["type_bottom"]!)!])
            }
        }
    }
}
//["color_type": "0"]
