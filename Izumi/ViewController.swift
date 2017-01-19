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
        let gradientLayer: CAGradientLayer = CAGradientLayer.init()
        gradientLayer.frame = viewController.view.bounds
        gradientLayer.colors =
            [
                UIColor.init(colorLiteralRed: 32/255, green: 23/255, blue: 164/255, alpha: 1).cgColor,
                UIColor.init(colorLiteralRed: 148/255, green: 68/255, blue: 197/255, alpha: 1).cgColor
            ]
        
        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 1.0)
        
        gradientLayer.zPosition = -1000.0
        
        viewController.view.layer.addSublayer(gradientLayer)
    }
}
