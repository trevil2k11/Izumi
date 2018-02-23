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

class RegistrationUserController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let helper = Helper();
    let retJSON = LibraryJSON();
    let curlSender = CurlController();
    
    var skin: [String] = [];
    var hair: [String] = [];
    
    var additionalArray:Array<Array<String>> = []
    var libDict:Array<Array<String>> = [];
    
    var newMedia: Bool?
    
    @IBOutlet weak var checkFields: UIButton!
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet weak var sexChanger: UISegmentedControl!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var dateBirth: UITextField!
    @IBOutlet weak var targetText: UITextView!
    @IBOutlet weak var backToLoginForm: UIButton!
    
    @IBOutlet weak var finishRegistration: UIButton!
    @IBOutlet weak var backToStep2: UIButton!
    @IBOutlet weak var backToStep3: UIButton!
    @IBOutlet weak var nextToStep4: UIButton!
    
    @IBOutlet weak var eyeColor: UIImageView!
    @IBOutlet weak var grayColorButton: CheckBox!
    @IBOutlet weak var blueColorButton: CheckBox!
    @IBOutlet weak var brownColorButton: CheckBox!
    @IBOutlet weak var greenColorButton: CheckBox!
    
    @IBOutlet weak var avatarPic: UIImageView!
    @IBOutlet weak var avatarContainer: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.view.backgroundColor = helper.getMainColor()
        super.viewWillAppear(animated)
        
        if (self.restorationIdentifier == "personalView") {
            helper.buttonDecorator(checkFields, backToLoginForm)
            helper.textFieldDecorator(loginText, emailText, pwdText, dateBirth)
            loginText.text = String(helper.loadUserDefaults("login"))
            emailText.text = helper.loadUserDefaults("email")
            dateBirth.text = helper.loadUserDefaults("dateBirth")
            if (helper.loadUserDefaults("sex").isEmpty == false) {
              sexChanger.selectedSegmentIndex = Int(helper.loadUserDefaults("sex"))!
            }
        }
        
        if (self.restorationIdentifier == "avatarView") {
            helper.buttonDecorator(backToStep2, nextToStep4)
            
            let eyeCl:UIColor = helper.loadEyeColor(key: "eyeColor")
            
            for singleSub in eyeColor.subviews {
                if singleSub.restorationIdentifier == "eyeColor" {
                    (singleSub as! PolyShape).setColor(
                        newColor: eyeCl,
                        rect: eyeColor.bounds
                    )
                    
                    for element in colorButtonsGroup.subviews {
                        if (eyeCl != (element as! CheckBox).value(forKeyPath: "colorForSetting") as! UIColor
                                &&
                            element.superclass == UIButton.self) {
                            (element as! CheckBox).isChecked = false;
                        } else {
                            (element as! CheckBox).isChecked = true;
                        }
                    }
                }
            }
        }
        
        if (self.restorationIdentifier == "aboutMeView") {
            helper.buttonDecorator(backToStep3, finishRegistration)
            helper.textFieldDecorator(skinColor, hairColor)
            helper.textViewDecorator(targetText)
            
            if helper.loadUserDefaults("hair").isEmpty == false {
                hairColor.text = hair[Int(helper.loadUserDefaults("hair"))!]
            }
            if helper.loadUserDefaults("skin").isEmpty == false {
                skinColor.text = skin[Int(helper.loadUserDefaults("skin"))!]
            }

            targetText.text = helper.loadUserDefaults("target")
        }
    }
    
    @IBOutlet weak var skinColor: UITextField!
    @IBOutlet weak var hairColor: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.hideKbrdWhenTapAround();
        
        skin = helper.returnSkin()
        hair = helper.returnHair()
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
        default:
            helper.showAlertMessage("err_pick", viewControl: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (self.restorationIdentifier == "figureView") {
            helper.doRound(avatarContainer, needBorder: false)
            drawEyeColor(rect: eyeColor.bounds)
        } else if (self.restorationIdentifier == "aboutMeView") {
            additionalArray.append(skin)
            additionalArray.append(hair)
            
            initPicker("0", tField: skinColor)
            initPicker("1", tField: hairColor)
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
            helper.showAlertMessage("err_no_cam", viewControl: self)
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
            helper.showAlertMessage("err_no_lib", viewControl: self)
        }
    }
    
    @IBOutlet weak var colorButtonsGroup: UIView!
    
    @IBAction func changeEyeColor(_ sender: UIButton) {
        for singleSub in eyeColor.subviews {
            if singleSub.restorationIdentifier == "eyeColor" {
                (singleSub as! PolyShape).setColor(
                    newColor: sender.value(forKey: "colorForSetting") as! UIColor,
                    rect: eyeColor.bounds
                )
                
                for element in colorButtonsGroup.subviews {
                    if (sender.restorationIdentifier != (element as! CheckBox).restorationIdentifier
                            &&
                        element.superclass == UIButton.self) {
                        (element as! CheckBox).isChecked = false;
                    }
                }
            }
        }
    }
    
    func drawEyeColor(rect: CGRect)->()
    {
        let newShape = PolyShape()
        newShape.restorationIdentifier = "eyeColor"
        newShape.mainColor = UIColor.blue
        newShape.drawRingFittingInsideView(rect: rect)
        eyeColor.addSubview(newShape)
    }
    
    @IBAction func datePickByTF(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.addTarget(self, action: #selector(RegistrationUserController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        datePickerView.setValue(UIColor.white, forKey: "textColor")
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        
        let doneButton =
            UIBarButtonItem(
                title: "Done",
                style: UIBarButtonItemStyle.plain,
                target: self,
                action: #selector(RegistrationUserController.donePicker)
            )
        
        let spaceButton =
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        addGradient(toolBar)
        addGradient(datePickerView)
        
        sender.inputView = datePickerView
        sender.inputAccessoryView = toolBar
    }
    
    func addGradient(_ objects: AnyObject...) {
        for object in objects {
            let gradientLayer: CAGradientLayer = CAGradientLayer.init()
            gradientLayer.frame = object.bounds
            gradientLayer.colors =
                [
                    UIColor.init(colorLiteralRed: 32/255, green: 23/255, blue: 164/255, alpha: 1).cgColor,
                    UIColor.init(colorLiteralRed: 148/255, green: 68/255, blue: 197/255, alpha: 1).cgColor
            ]
            
            gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 1.0)
            
            gradientLayer.zPosition = -1000.0
            
            object.layer.addSublayer(gradientLayer)
        }
    }
    
    func donePicker(sender: UIBarButtonItem) {
        dateBirth.resignFirstResponder()
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
        if (self.restorationIdentifier == "personalView") {
            let allRFNE: Int = checkEmpty(loginText) + checkEmpty(pwdText) + checkEmpty(emailText) + checkEmpty(dateBirth);
            if (allRFNE == 0) {
                helper.clearCoreData();
                helper.saveUserDefaults(loginText.text!, key: "login")
                helper.saveUserDefaults(helper.md5(pwdText.text!), key: "pwd")
                helper.saveUserDefaults(emailText.text!, key: "email")
                helper.saveUserDefaults(dateBirth.text!, key: "dateBirth")
                helper.saveUserDefaults(String(sexChanger.selectedSegmentIndex), key: "sex")
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
            helper.textFieldDecorator(tField)
        }
        return result;
    }
    
    @IBAction func goToNextStepAction(_ sender: UIButton) {
        if (self.restorationIdentifier == "aboutMeView") {
            
            helper.saveEyeColor(getPickedColor(), key: "eyeColor")
        }
        
        helper.goToScreen(sender.restorationIdentifier!, parent: self)
    }

    func getPickedColor()->UIColor {
        if (grayColorButton.isChecked == true) {return grayColorButton.colorForSetting}
        else if (greenColorButton.isChecked == true) {return greenColorButton.colorForSetting}
        else if (blueColorButton.isChecked == true) {return blueColorButton.colorForSetting}
        else {return brownColorButton.colorForSetting}
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.contains(kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            if (self.restorationIdentifier == "avatarView") {
                avatarPic.image = image
                helper.compressImageAndStore(image, keyStr: "avatarPic")
            }
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(
                    image,
                    self,
                    #selector(
                        AddPicture.image(
                            _:didFinishSavingWithError:contextInfo:
                        )
                    ),
                    nil
                )
            } else if mediaType.contains(kUTTypeMovie as String) {
                // Code to support video here
            }
            
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSErrorPointer?, contextInfo:UnsafeRawPointer) {
        if error != nil {
            helper.showAlertMessage("err_save", viewControl: self)
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
                    self.helper.showAlertMessage(json["data"].stringValue, viewControl: self)
                }
            }
        }
    }
}
