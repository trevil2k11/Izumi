//
//  RegistrationController.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 31.03.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MobileCoreServices

class RegistrationUserController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let helper = Helper();
    let retJSON = LibraryJSON();
    let curlSender = CurlController();
    
    var bodyUpLib: [String] = [];
    var bodyMidUpperLib: [String] = [];
    var bodyMidBottomLib: [String] = [];
    var bodyBottomLib: [String] = [];
    var bodyKeys: [String] = [];
    
    var skin: [String] = [];
    var hair: [String] = [];
    var brown: [String] = [];
    var venous_color: [String] = [];
    
    var additionalArray:Array<Array<String>> = []
    var libDict:Array<Array<String>> = [];
    
    var selectedLibrary: Int = 0;
    var currentKey: String = "UpperBody";
    var newMedia: Bool?
    
    @IBOutlet weak var bodyImg: UIImageView!
    @IBOutlet weak var bodyStepper: UIStepper!
    
    @IBOutlet weak var checkFields: UIButton!
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet weak var sexChanger: UISegmentedControl!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var dateBirth: UITextField!
    @IBOutlet weak var targetText: UITextView!
    @IBOutlet weak var backToStep1: UIButton!
    
    @IBOutlet weak var fullPicture: UIImageView!
    
    @IBOutlet weak var eyeColor: UIImageView!
    
    @IBOutlet weak var avatarPic: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.restorationIdentifier == "userRegistrationStep1") {
            loginText.text = String(helper.loadUserDefaults("login"))
            emailText.text = helper.loadUserDefaults("email")
            dateBirth.text = helper.loadUserDefaults("dateBirth")
            if (helper.loadUserDefaults("sex").isEmpty == false) {
              sexChanger.selectedSegmentIndex = Int(helper.loadUserDefaults("sex"))!
            }
            targetText.text = helper.loadUserDefaults("target")
        }
        
        if (self.restorationIdentifier == "userRegistrationStep2") {
            if (helper.loadUserDefaults("fullPicture").isEmpty == false) {
                fullPicture.image = helper.loadImageFromLib("fullPicture")
            }
        }
        
        if (self.restorationIdentifier == "userRegistrationStep3") {
            if (helper.loadUserDefaults("avatarPic").isEmpty == false) {
                avatarPic.image = helper.loadImageFromLib("avatarPic")
            }
            if helper.loadUserDefaults("hair").isEmpty == false {
                hairColor.text = hair[Int(helper.loadUserDefaults("hair"))!]
            }
            if helper.loadUserDefaults("skin").isEmpty == false {
                skinColor.text = skin[Int(helper.loadUserDefaults("skin"))!]
            }
            if helper.loadUserDefaults("brown").isEmpty == false {
                brownColor.text = brown[Int(helper.loadUserDefaults("brown"))!]
            }
            if helper.loadUserDefaults("venousColor").isEmpty == false {
                venousColor.text = venous_color[Int(helper.loadUserDefaults("venousColor"))!]
            }
        }
    }
    
    @IBOutlet weak var skinColor: UITextField!
    @IBOutlet weak var brownColor: UITextField!
    @IBOutlet weak var hairColor: UITextField!
    @IBOutlet weak var venousColor: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.hideKbrdWhenTapAround();
        
        bodyUpLib = helper.returnBodyUpLib()
        bodyMidUpperLib = helper.returnMidUpperLib()
        bodyMidBottomLib = helper.returnMidBottomLib()
        bodyBottomLib = helper.returnBodyBottomLib()
        bodyKeys = helper.returnBodyKeys()
        
        skin = helper.returnSkin()
        hair = helper.returnHair()
        brown = helper.returnBrown()
        venous_color = helper.returnVenous()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return additionalArray[Int(pickerView.restorationIdentifier!)!].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return additionalArray[Int(pickerView.restorationIdentifier!)!][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.restorationIdentifier! {
        case "0":
            skinColor.text = skin[row];
            helper.saveUserDefaults(String(row), key: "skin")
        case "1":
            hairColor.text = hair[row];
            helper.saveUserDefaults(String(row), key: "hair")
        case "2":
            brownColor.text = brown[row];
            helper.saveUserDefaults(String(row), key: "brown")
        case "3":
            venousColor.text = venous_color[row];
            helper.saveUserDefaults(String(row), key: "venousColor")
        default:
            helper.showAlertMessage("err_pick")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (self.restorationIdentifier == "userRegistrationStep2") {
            libDict = helper.returnFullBody()
            
            initGallery();
        }
        if (self.restorationIdentifier == "userRegistrationStep3") {
            additionalArray.append(skin)
            additionalArray.append(hair)
            additionalArray.append(brown)
            additionalArray.append(venous_color)
            
            initPicker("0", tField: skinColor)
            initPicker("1", tField: hairColor)
            initPicker("2", tField: brownColor)
            initPicker("3", tField: venousColor)
        }
    }

    func initPicker(_ restId: String, tField: UITextField) -> UIPickerView {
        let pickView = UIPickerView()
        pickView.delegate = self
        pickView.dataSource = self
        pickView.restorationIdentifier = restId
        tField.inputView = pickView
        
        return pickView
    }
    
    @IBAction func changeGallery(_ sender: UIButton) {
        selectedLibrary = Int(sender.accessibilityLabel!)!;
        currentKey = sender.restorationIdentifier!;
        initGallery();
    }
    
    func initGallery() {
        if (helper.loadUserDefaults(currentKey).isEmpty == false) {
            bodyImg.image = UIImage(named: libDict[selectedLibrary][Int(helper.loadUserDefaults(currentKey))!])
            bodyStepper.value = Double(helper.loadUserDefaults(currentKey))!
        } else {
            bodyImg.image = UIImage(named: libDict[Int(selectedLibrary)][0])
            bodyStepper.value = Double(0)
        }
    }
    
    @IBAction func getCameraPict(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true,
                                           completion: nil)
            newMedia = true
        } else {
            helper.showAlertMessage("err_no_cam")
        }
    }
    
    @IBAction func getLibPict(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true,
                                       completion: nil)
            newMedia = false
        } else {
            helper.showAlertMessage("err_no_lib")
        }
    }
    
    @IBAction func changeEyeColor(_ sender: UIButton) {
        eyeColor.backgroundColor = sender.backgroundColor
    }
    
    
    @IBAction func changePict(_ sender: UIStepper) {
        bodyImg.image = UIImage(named: libDict[selectedLibrary][Int(sender.value)])
        helper.saveUserDefaults(String(Int(sender.value)), key: currentKey)
    }
    
    @IBAction func datePickByTF(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(RegistrationUserController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateBirth.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func returnStep1(_ sender: AnyObject) {
        helper.goToScreen((sender.accessibilityLabel!)!, parent: self)
    }
    
    @IBAction func checkRequiredFields(_ sender: AnyObject) {
        if (self.restorationIdentifier == "userRegistrationStep1") {
            let allRFNE: Int = checkEmpty(loginText) + checkEmpty(pwdText) + checkEmpty(emailText) + checkEmpty(dateBirth);
            if (allRFNE == 0) {
                helper.clearCoreData();
                helper.saveUserDefaults(loginText.text!, key: "login")
                helper.saveUserDefaults(helper.md5(pwdText.text!), key: "pwd")
                helper.saveUserDefaults(emailText.text!, key: "email")
                helper.saveUserDefaults(dateBirth.text!, key: "dateBirth")
                helper.saveUserDefaults(String(sexChanger.selectedSegmentIndex), key: "sex")
                helper.saveUserDefaults(targetText.text!, key: "target")
                helper.goToScreen("userRegistrationStep2", parent: self)
            }
        }
    }
    
    @IBAction func onEditEnd(_ sender: UITextField) {
        checkEmpty(sender)
    }
    
    func checkEmpty(_ tField: UITextField)->Int {
        var result: Int = 0;
        if (tField.text?.isEmpty == true) {
            tField.layer.borderWidth = 1;
            tField.layer.borderColor = UIColor.red.cgColor;
            result += 1;
        } else {
            tField.layer.borderWidth = 0;
        }
        return result;
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.contains(kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            if (self.restorationIdentifier == "userRegistrationStep2") {
                fullPicture.image = image
                helper.compressImageAndStore(image, keyStr: "fullPicture")
            } else if (self.restorationIdentifier == "userRegistrationStep3") {
                avatarPic.image = image
                helper.compressImageAndStore(image, keyStr: "avatarPic")
            }
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                                               #selector(AddPicture.image(_:didFinishSavingWithError:contextInfo:)), nil)
            } else if mediaType.contains(kUTTypeMovie as String) {
                // Code to support video here
            }
            
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSErrorPointer?, contextInfo:UnsafeRawPointer) {
        if error != nil {
            helper.showAlertMessage("err_save")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishUserRegistration(_ sender: UIButton) {
        
        let keyValNoCheck = helper.returnKeyValNoCheck();
        let keyValCheck = helper.returnKeyValCheck();
        
        var params: [String:String] = [:];
        
        for (key,val) in keyValNoCheck {
            params[key] = helper.loadUserDefaults(val);
        }
        for (key,val) in keyValCheck {
            params[key] = helper.loadUserDefaults(val).isEmpty == false ? helper.loadUserDefaults(val) : "";
        }
        
        curlSender.sendData(retJSON.returnCreateUser(params)) {result in
            let data = result!.data(using: String.Encoding.utf8.rawValue)
            var json = JSON(data: data!)
            OperationQueue.main.addOperation {
                if Int(json["data"].stringValue) == 1 {
                    self.helper.goToScreen("UserEntrance", parent: self)
                } else {
                    self.helper.showAlertMessage(json["data"].stringValue)
                }
            }
        }
    }
    
    
}
