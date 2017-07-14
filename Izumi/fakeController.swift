//
//  fakeController.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 15.11.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import Foundation
import UIKit

class fakeController: UIViewController {
    var helperLib = Helper()
    
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKbrdWhenTapAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        helperLib.buttonDecorator(startBtn, bordered: true)
    }
    
    @IBAction func startRegistration(_ sender: UIButton) {
        helperLib.goToScreen("SimpleEntrance", parent: self)
    }
}
