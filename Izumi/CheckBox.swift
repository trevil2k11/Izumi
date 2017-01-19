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
    
    let imgChecked: UIImage = #imageLiteral(resourceName: "checked")
    let imgUnchecked: UIImage = #imageLiteral(resourceName: "unchecked")

    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(imgChecked, for: .normal)
            } else {
                self.setImage(imgUnchecked, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.buttonClicked), for: .touchUpInside)
        self.isChecked = helperLib.loadDefaultOrChecked("figureType")
    }
    
    func buttonClicked(sender: UIButton) {
        if (sender == self) {
            isChecked = !isChecked
            helperLib.setChecked(isChecked, key: "figureSelection")
        }
    }
}
