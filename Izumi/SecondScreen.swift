//
//  SecondScreen.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 19.05.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import Foundation
import UIKit

class SecondScreen: UIViewController {
    @IBOutlet weak var userInviteTextView: UITextView!
    @IBOutlet weak var stylistInviteTextView: UITextView!
    
    @IBOutlet weak var userEntranceButton: UIButton!
    @IBOutlet weak var stylistEntranceButton: UIButton!
    let helperLib = Helper();
    
    @IBOutlet var userEnter: UIView!
    @IBOutlet weak var stylistEnter: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.setGradient(viewController: self)
        helperLib.textViewDecorator(
            userInviteTextView,
            stylistInviteTextView,
            bordered: false
        )
        
        helperLib.buttonDecorator(
            userEntranceButton,
            stylistEntranceButton
        )
    }
    
    @IBAction func userEnterAction(_ sender: UIButton) {
        self.helperLib.saveUserDefaults("user", key: "type")
    }
    
    @IBAction func stylistEnterAction(_ sender: UIButton) {
        self.helperLib.saveUserDefaults("stylist", key: "type")
    }
    
}
