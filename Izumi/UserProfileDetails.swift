//
//  UserProfileDetails.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 02.07.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import UIKit

class UserProfileDetails: UIViewController {
    let helperLib = Helper();
    let curlSender = CurlController();
    let LibJSON = LibraryJSON();
    
    @IBOutlet weak var skinField: UITextField!
    @IBOutlet weak var brownField: UITextField!
    @IBOutlet weak var hairField: UITextField!
    @IBOutlet weak var venousField: UITextField!
    
    @IBOutlet weak var eyeColor: UIImageView!
    
    @IBOutlet weak var aboutMyself: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let data = LibJSON.returnUserDetails(helperLib.loadUserDefaults("user_id"));
        curlSender.sendData(data) { (result) in
            OperationQueue.main.addOperation {
                let dict: [String:String] = self.helperLib.returnDictFromJSON(result!)[0]
            
                self.skinField.text = dict["skin"]
                self.brownField.text = dict["brown"]
                self.hairField.text = dict["hair"]
                self.venousField.text = dict["venous"]
            
                switch dict["eyes"]! {
                    case "0":
                        self.eyeColor.backgroundColor = UIColor(red: 0.25098, green: 0.501961, blue: 0, alpha: 1);
                    case "1":
                        self.eyeColor.backgroundColor = UIColor(red: 0, green: 0.501961, blue: 1, alpha: 1);
                    case "2":
                        self.eyeColor.backgroundColor = UIColor(red: 0.701961, green: 0.701961, blue: 0.701961, alpha: 1);
                    case "3":
                        self.eyeColor.backgroundColor = UIColor(red: 0.501961, green: 0.25098, blue: 0, alpha: 1);
                    default:
                        self.eyeColor.backgroundColor = UIColor(red: 0.25098, green: 0.501961, blue: 0, alpha: 1);
                }
            
                self.aboutMyself.attributedText = self.helperLib.returnNSAttrStringWithStdFormat(dict["user_comment"]!).mutableCopy() as! NSAttributedString
            }
        }
    }
}
