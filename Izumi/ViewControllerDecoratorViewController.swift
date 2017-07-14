//
//  ViewControllerDecoratorViewController.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 15.01.17.
//  Copyright © 2017 Ilya Kosolapov. All rights reserved.
//

import UIKit

class ViewControllerDecoratorViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    @IBOutlet weak var listLeft: UIButton!
    @IBOutlet weak var listRight: UIButton!
    
    @IBOutlet weak var triangleCheckBox: CheckBox!
    @IBOutlet weak var revertTriangleCheckBox: CheckBox!
    @IBOutlet weak var hourglassCheckBox: CheckBox!
    
    var helperLib = Helper()
    var descriptions = DescriptionLibrary()
    
    @IBOutlet weak var triangleHelp: UIButton!
    override func viewDidLoad() {
        super.setGradient(viewController: self)
        helperLib.buttonDecorator(backButton, nextButton)
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickOnCheckBox(_ sender: CheckBox) {
        if sender.restorationIdentifier == "triangle" {
            setFalse(sender, revertTriangleCheckBox, hourglassCheckBox)
        } else if sender.restorationIdentifier == "revertTriangle" {
            setFalse(sender, triangleCheckBox, hourglassCheckBox)
        } else {
            setFalse(sender, revertTriangleCheckBox, triangleCheckBox)
        }
    }
    
    func setFalse(_ checkBoxes: CheckBox...) {
        helperLib.setChecked(true, key: checkBoxes[0].restorationIdentifier!)
        helperLib.setChecked(false, key: checkBoxes[1].restorationIdentifier!)
        helperLib.setChecked(false, key: checkBoxes[2].restorationIdentifier!)
    }
    
    @IBAction func showDescription(_ sender: UIButton) {
        let titleAndDescription
            = descriptions.returnDescription(sender.restorationIdentifier!)
        helperLib.showNewMessage(
            title: titleAndDescription["title"]!,
            description: titleAndDescription["descr"]!,
            viewControl: self)
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        helperLib.goToScreen("UserRegistrationStep1", parent: self)
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        helperLib.goToScreen("UserRegistrationStep3", parent: self)
    }
}
