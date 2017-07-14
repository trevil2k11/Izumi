//
//  SimpleAuthController.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 16.04.17.
//  Copyright © 2017 Ilya Kosolapov. All rights reserved.
//

import UIKit

class SimpleAuthController: UIViewController {

    var helperLib = Helper()
    var jsonLib = LibraryJSON()
    var curlSender = CurlController()
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var saveMe: UISwitch!
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.setGradient(viewController: self)
        super.viewDidLoad()
        
        view.backgroundColor = helperLib.getMainColor()
        helperLib.textFieldDecorator(login, password)
        helperLib.buttonDecorator(
            enterButton,
            registerButton,
            bordered: true
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tryToAuth(_ sender: UIButton!) {
            if (login.text?.isEmpty == true) {
                helperLib.showAlertMessage("err_no_login", viewControl: self)
            } else if (password.text?.isEmpty == true) {
                helperLib.showAlertMessage("err_no_pass", viewControl: self)
            } else {
                self.helperLib.saveUserDefaults("user", key: "user_type")
                self.helperLib.saveUserDefaults(self.login.text!, key: "userL")
                self.helperLib.saveUserDefaults(self.helperLib.md5(self.password.text!), key: "userP")
                authLogPass(self.login.text!, pwd: helperLib.md5(self.password.text!), nextScreen: "userProfile");
            }
    }

    func authLogPass(_ log: String, pwd: String, nextScreen: String) -> Void{
        let body = jsonLib.returnAuth(log, pwd: pwd)
        
        self.helperLib.saveUserDefaults(String(true), key: "autoLogin")
        
        curlSender.sendData(body) {result in
            OperationQueue.main.addOperation {
                let res = self.helperLib.returnDictFromJSON(result!);
                
                if (res.count > 0) {
                    if (res[0]["user_type"] == "0") {
                        self.helperLib.saveUserDefaults("user", key: "user_type")
                    } else if (res[0]["user_type"] == "1") {
                        self.helperLib.saveUserDefaults("stylist", key: "user_type")
                    }
                    
                    self.helperLib.saveUserDefaults(res[0]["id"]!, key: "user_id")
                    self.helperLib.saveData("no", key: "firstEntrance")
                    
                    if (res[0]["user_type"] == "1") {
                        self.updateStylistActivity();
                        Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(self.updateStylistActivity), userInfo: nil, repeats: true)
                    }
                    self.helperLib.goToScreen("libraryMain", parent: self)
                } else {
                    self.helperLib.showAlertMessage("err_no_user", viewControl: self);
                }
            }
        }
    }
    
    func updateStylistActivity(){
        print(self.jsonLib.returnUpdateStylistActivity(self.helperLib.loadUserDefaults("user_id")))
        self.curlSender.sendData(self.jsonLib.returnUpdateStylistActivity(self.helperLib.loadUserDefaults("user_id"))) { (result) in
        }
    }
    
    @IBAction func changeSaveMe(_ sender: UISwitch) {
        helperLib.saveUserDefaults(String(sender.isOn), key: "autoLogin")
    }
}
