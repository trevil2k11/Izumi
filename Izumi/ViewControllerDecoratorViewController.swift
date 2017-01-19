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

    var helperLib = Helper()
    
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
    
    @IBAction func triangleHelpAction(_ sender: Any) {
        helperLib.showNewMessage(title: "test", description: "test", viewControl: self)
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
