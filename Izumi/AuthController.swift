//
//  AuthController.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 09.03.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MobileCoreServices

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class AuthController: UIViewController {
    fileprivate var helperLib = Helper();
    fileprivate var curlSender = CurlController();
    fileprivate var jsonLib = LibraryJSON();
    
    fileprivate var result: NSString?;
    
    @IBOutlet weak var usrBtn: UIButton!
    @IBOutlet weak var stlBtn: UIButton!
    @IBOutlet weak var usrLogin: UITextField!
    @IBOutlet weak var stlLogin: UITextField!
    @IBOutlet weak var usrPwd: UITextField!
    @IBOutlet weak var stlPwd: UITextField!
    
    @IBOutlet weak var saveMeUsr: UISwitch!
    @IBOutlet weak var saveMeStl: UISwitch!
    
    @IBOutlet weak var regUsr: UIButton!
    @IBOutlet weak var backUsr: UIButton!
    
    @IBAction func regBeginAction(_ sender: UIButton) {
        helperLib.clearUserDefaultsInRegistration()
        helperLib.goToScreen("UserRegistrationStep1", parent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.setGradient(viewController: self)
        
        if (self.restorationIdentifier! == "UserEntrance") {
            helperLib.buttonDecorator(usrBtn, regUsr, backUsr)
            helperLib.textFieldDecorator(usrLogin, usrPwd)
        } else if (self.restorationIdentifier! == "StylistEntrance") {
            helperLib.buttonDecorator(stlBtn)
            helperLib.textFieldDecorator(stlLogin, stlPwd)
        }
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.hideKbrdWhenTapAround();
    }
    
    func updateStylistActivity(){
        print(self.jsonLib.returnUpdateStylistActivity(self.helperLib.loadUserDefaults("user_id")))
        self.curlSender.sendData(self.jsonLib.returnUpdateStylistActivity(self.helperLib.loadUserDefaults("user_id"))) { (result) in
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if helperLib.loadUserDefaults("autoLogin").isEmpty == false {
            if (self.restorationIdentifier! == "UserEntrance") {
                saveMeUsr.isOn = (helperLib.loadUserDefaults("autoLogin") == "true" ||
                    helperLib.loadUserDefaults("autoLogin") == "1") ? true : false;
            } else if (self.restorationIdentifier! == "StylistEntrance") {
                saveMeStl.isOn = (helperLib.loadUserDefaults("autoLogin") == "true" ||
                    helperLib.loadUserDefaults("autoLogin") == "1") ? true : false;
            }
            
            if self.helperLib.loadData("firstEntrance").isEmpty == false
                && self.helperLib.loadUserDefaults("userL").isEmpty == false
                && self.helperLib.loadUserDefaults("userP").isEmpty == false {
                
                let log: String = self.helperLib.loadUserDefaults("userL")
                let pwd: String = self.helperLib.loadUserDefaults("userP")
                
                if self.restorationIdentifier! == "UserEntrance" && saveMeUsr.isOn == true {
                    usrLogin.text = log;
                    usrPwd.text = "*****";
                    self.helperLib.saveUserDefaults("user", key: "user_type")
                    self.authLogPass(log, pwd: pwd, nextScreen: "userProfile")
                } else if self.restorationIdentifier! == "StylistEntrance" && saveMeStl.isOn == true {
                    stlLogin.text = log;
                    stlPwd.text = "*****"
                    self.helperLib.saveUserDefaults("stylist", key: "user_type")
                    self.authLogPass(log, pwd: pwd, nextScreen: "stylistProfile")
                }
            }
        }
    }
    
    @IBAction func tryToAuth(_ sender: UIButton!) {
        if (sender.accessibilityLabel == "userAuth") {
            if (usrLogin.text?.isEmpty == true) {
                helperLib.showAlertMessage("err_no_login", viewControl: self)
            } else if (usrPwd.text?.isEmpty == true) {
                helperLib.showAlertMessage("err_no_pass", viewControl: self)
            } else {
                self.helperLib.saveUserDefaults("user", key: "user_type")
                self.helperLib.saveUserDefaults(self.usrLogin.text!, key: "userL")
                self.helperLib.saveUserDefaults(self.helperLib.md5(self.usrPwd.text!), key: "userP")
                authLogPass(self.usrLogin.text!, pwd: helperLib.md5(self.usrPwd.text!), nextScreen: "userProfile");
            }
        } else if (sender.accessibilityLabel == "stylistAuth"){
            if (stlLogin.text?.isEmpty == true) {
                helperLib.showAlertMessage("err_no_login", viewControl: self)
            } else if (stlPwd.text?.isEmpty == true) {
                helperLib.showAlertMessage("err_no_pass", viewControl: self)
            } else {
                self.helperLib.saveUserDefaults("stylist", key: "user_type")
                self.helperLib.saveUserDefaults(self.stlLogin.text!, key: "userL")
                self.helperLib.saveUserDefaults(self.helperLib.md5(self.stlPwd.text!), key: "userP")
                authLogPass(self.stlLogin.text!, pwd: helperLib.md5(self.stlPwd.text!), nextScreen: "stylistProfile");
            }
        }
    }
    
    func authLogPass(_ log: String, pwd: String, nextScreen: String) -> Void{
        let body = jsonLib.returnAuth(log, pwd: pwd)
        
        if (self.restorationIdentifier! == "UserEntrance") {
            self.helperLib.saveUserDefaults("user", key: "user_type")
            self.helperLib.saveUserDefaults(String(saveMeUsr.isOn), key: "autoLogin")
        } else if (self.restorationIdentifier! == "StylistEntrance") {
            self.helperLib.saveUserDefaults("stylist", key: "user_type")
            self.helperLib.saveUserDefaults(String(saveMeStl.isOn), key: "autoLogin")
        }
        
        curlSender.sendData(body) {result in
            OperationQueue.main.addOperation {
                let res = self.helperLib.getResFromJSON(result!);
                if (Int(res) > 0) {
                    self.helperLib.saveUserDefaults(res, key: "user_id")
                    self.helperLib.saveData("no", key: "firstEntrance")
                    
                    if (self.restorationIdentifier! == "StylistEntrance") {
                        self.updateStylistActivity();
                        Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(self.updateStylistActivity), userInfo: nil, repeats: true)
                    }
                    self.helperLib.goToScreen("libraryMain", parent: self)
                } else {
                    self.helperLib.showAlertMessage(res, viewControl: self);
                }
            }
        }
    }
    
    @IBAction func changeSaveMe(_ sender: UISwitch) {
        helperLib.saveUserDefaults(String(sender.isOn), key: "autoLogin")
    }
    
}
