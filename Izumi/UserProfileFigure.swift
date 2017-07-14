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
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let data = LibJSON.returnUserDetails(helperLib.loadUserDefaults("user_id"));
        curlSender.sendData(data) { (result) in
            OperationQueue.main.addOperation {
//                let dict: [String:String] = self.helperLib.returnDictFromJSON(result!)[0]                
            }
        }
    }
}
