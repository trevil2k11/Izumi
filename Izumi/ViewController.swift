//
//  ViewController.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 29.02.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKbrdWhenTapAround();
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UIViewController {
    func hideKbrdWhenTapAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKbrd));
        view.addGestureRecognizer(tap);
    }
    
    func dismissKbrd() {
        view.endEditing(true);
    }
    
    func calcButtonWidth (_ toolbar: UIToolbar) {
        for item: UIBarButtonItem in toolbar.items! {
            item.width = (self.view.bounds.width - 70)/CGFloat((toolbar.items?.count)!);
        }
    }
    
    func setGradient(viewController: UIViewController) {
        viewController.view.backgroundColor = UIColor.init(colorLiteralRed: 94/255, green: 67/255, blue: 191/255, alpha: 1)
//        let gradientLayer: CAGradientLayer = CAGradientLayer.init()
//        gradientLayer.frame = viewController.view.bounds
//        gradientLayer.backgroundColor = UIColor.init(colorLiteralRed: 94/255, green: 67/255, blue: 191/255, alpha: 1)
//        gradientLayer.zPosition = -1000.0
//        viewController.view.layer.addSublayer(gradientLayer)
    }
}
