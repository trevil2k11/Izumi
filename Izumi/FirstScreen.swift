//
//  FirstScreen.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 19.05.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import Foundation
import UIKit

class FirstScreen: UIViewController {
    
    let helperLib = Helper();
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.helperLib.loadUserDefaults("firstEntrance").isEmpty == true {
            helperLib.saveUserDefaults("no", key: "firstEntrance")
        } else if self.helperLib.loadUserDefaults("type") == "user" {
            helperLib.goToScreen("UserEntrance", parent: self)
        } else if self.helperLib.loadUserDefaults("type") == "stylist" {
            helperLib.goToScreen("StylistEntrance", parent: self)
        }
    }
}
