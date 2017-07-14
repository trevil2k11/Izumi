//
//  CheckBox.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 17.01.17.
//  Copyright © 2017 Ilya Kosolapov. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

    let helperLib = Helper()
    
    @IBInspectable var imgChecked: UIImage = #imageLiteral(resourceName: "checked")
    @IBInspectable var imgUnchecked: UIImage = #imageLiteral(resourceName: "unchecked")

    @IBInspectable var colorForSetting: UIColor = UIColor.white
    
    @IBInspectable var isChecked: Bool = false
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.buttonClicked), for: .touchUpInside)
        self.isSelected = helperLib.loadDefaultOrChecked(self.restorationIdentifier!)
        
        setByBool()
    }
    
    func buttonClicked(sender: UIButton) {
        if (sender == self) {
            isChecked = !isChecked
            helperLib.setChecked(isChecked, key: self.restorationIdentifier!)
        }
        
        setByBool()
    }
    
    func setByBool() {
        if (isChecked) {
            self.setImage(imgChecked, for: .normal)
        } else {
            self.setImage(imgUnchecked, for: .normal)
        }
    }
}
