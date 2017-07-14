//
//  RegistrationStylistController.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 04.07.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import UIKit
import MobileCoreServices

class RegistrationStylistController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate {
    
    let helperLib = Helper();
    let LibJSON = LibraryJSON();
    let curlSender = CurlController();
    //Step1 objects
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var fioField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var sexSegment: UISegmentedControl!
    @IBOutlet weak var dateBirth: UITextField!
    @IBOutlet weak var educationField: UITextField!
    @IBOutlet weak var expirienceField: UITextField!
    @IBOutlet weak var projectsField: UITextField!
    
    @IBOutlet weak var nextButtonStep1: UIButton!
    
    //Step2 objects
    @IBOutlet weak var avatarPhotoBtn: UIButton!
    @IBOutlet weak var diplomaPhotoBtn: UIButton!
    
    @IBOutlet weak var avatarGalleryBtn: UIButton!
    @IBOutlet weak var diplomaGalleryBtn: UIButton!
    
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var diplomaImgView: UIImageView!
    
    @IBOutlet weak var registrationFinishBtn: UIButton!
    
    var newMedia: Bool?
    var currentImgView: UIImageView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.setGradient(viewController: self)
        super.viewWillAppear(animated)
        
        if (self.restorationIdentifier == "stylistRegistrationStep1") {
            helperLib.textFieldDecorator(
                nicknameField,
                passwordField,
                fioField,
                emailField,
                dateBirth,
                educationField,
                expirienceField,
                projectsField
            )
            helperLib.buttonDecorator(nextButtonStep1)
        }
        
        if self.restorationIdentifier == "stylistRegistrationStep2" {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKbrdWhenTapAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.currentImgView = avatarImgView
        
        if self.restorationIdentifier == "stylistRegistrationStep1" {
            nicknameField.text = helperLib.loadUserDefaults("login").isEmpty == false ? helperLib.loadUserDefaults("login") : ""
            fioField.text = helperLib.loadUserDefaults("fio").isEmpty == false ? helperLib.loadUserDefaults("fio") : ""
            emailField.text = helperLib.loadUserDefaults("email").isEmpty == false ? helperLib.loadUserDefaults("email") : ""
            dateBirth.text = helperLib.loadUserDefaults("dateBirth").isEmpty == false ? helperLib.loadUserDefaults("dateBirth") : ""
            sexSegment.selectedSegmentIndex = helperLib.loadUserDefaults("sex").isEmpty == false ? Int(helperLib.loadUserDefaults("sex"))! : 1
            educationField.text = helperLib.loadUserDefaults("education").isEmpty == false ? helperLib.loadUserDefaults("education") : ""
            expirienceField.text! = helperLib.loadUserDefaults("expirience").isEmpty == false ? helperLib.loadUserDefaults("expirience") : ""
            projectsField.text = helperLib.loadUserDefaults("projects").isEmpty == false ? helperLib.loadUserDefaults("projects") : ""
        } else if self.restorationIdentifier == "stylistRegistrationStep2" {
            avatarImgView.image = helperLib.loadUserDefaults("avatar").isEmpty == false ? helperLib.loadImageFromLib("avatar") : nil
            diplomaImgView.image = helperLib.loadUserDefaults("diploma").isEmpty == false ? helperLib.loadImageFromLib("diploma") : nil
        }
    }
    
    @IBAction func selectPhotoView(_ sender: UIButton) {
        if sender.restorationIdentifier == "avatarPhotoBtn"
            ||
           sender.restorationIdentifier == "avatarGalleryBtn"
        {
            self.currentImgView = self.avatarImgView
        } else {
            self.currentImgView = self.diplomaImgView
        }
        if sender.restorationIdentifier == "avatarPhotoBtn"
            ||
           sender.restorationIdentifier == "diplomaPhotoBtn"
        {
            cameraTakePicture();
        } else {
            libraryTakePicture()
        }
    }
    
    func cameraTakePicture() {
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
            helperLib.showAlertMessage("err_no_cam", viewControl: self)
        }
    }
    
    func libraryTakePicture() {
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
            helperLib.showAlertMessage("err_no_lib", viewControl: self)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.contains(kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            self.currentImgView!.image = image
            
            self.helperLib.compressImageAndStore(image, keyStr: (self.currentImgView?.restorationIdentifier)!)
            
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
            helperLib.showAlertMessage("err_save", viewControl: self)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
            helperLib.textFieldDecorator(tField)
        }
        return result;
    }

    @IBAction func backToMainScreen(_ sender: UIButton) {
        helperLib.clearStylistDefaultInRegistration();
        helperLib.goToScreen(sender.restorationIdentifier!, parent: self)
    }
    
    
    @IBAction func checkFieldsAndGoToStep2(_ sender: UIButton) {
        if self.restorationIdentifier == "stylistRegistrationStep1" {
            let allCheck: Int = checkEmpty(nicknameField) +
                                checkEmpty(passwordField) +
                                checkEmpty(fioField) +
                                checkEmpty(emailField) +
                                checkEmpty(dateBirth) +
                                checkEmpty(educationField) +
                                checkEmpty(expirienceField);
            print(allCheck)
            if allCheck == 0 {
                helperLib.clearStylistDefaultInRegistration();
                helperLib.saveUserDefaults(nicknameField.text!, key: "login")
                helperLib.saveUserDefaults(helperLib.md5(passwordField.text!), key: "pwd")
                helperLib.saveUserDefaults(fioField.text!, key: "fio")
                helperLib.saveUserDefaults(emailField.text!, key: "email")
                helperLib.saveUserDefaults(dateBirth.text!, key: "dateBirth")
                helperLib.saveUserDefaults(String(sexSegment.selectedSegmentIndex), key: "sex")
                helperLib.saveUserDefaults(educationField.text!, key: "education")
                helperLib.saveUserDefaults(expirienceField.text!, key: "expirience")
                helperLib.saveUserDefaults(projectsField.text!, key: "projects")
                helperLib.goToScreen("stylistRegistrationStep2", parent: self)
            }
        }
    }
    
    @IBAction func finishStylistRegistration(_ sender: UIButton) {
        if self.restorationIdentifier == "stylistRegistrationStep2" {
            if avatarImgView.image != nil && diplomaImgView.image != nil {
                let keyVal = helperLib.returnStylistKeyVal();
                var params: [String:String] = [:];
                
                for (key,val) in keyVal {
                    params[key] = helperLib.loadUserDefaults(val);
                }
                
                let body = LibJSON.returnCreateStylist(params)
                
                curlSender.sendData(body, completionHandler: { (result) in
                    let data = result!.data(using: String.Encoding.utf8.rawValue)
                    var json = JSON(data: data!)
                    OperationQueue.main.addOperation {
                        print(json)
                        if Int(json["data"].stringValue) == 1 {
                            self.helperLib.goToScreen("StylistEntrance", parent: self)
                        } else {
                            self.helperLib.showAlertMessage(json["data"].stringValue, viewControl: self)
                        }
                    }
                })
            } else if avatarImgView.image == nil {
                helperLib.showAlertMessage("no_avatar", viewControl: self);
            } else if diplomaImgView.image == nil {
                helperLib.showAlertMessage("no_diploma", viewControl: self)
            }
        }
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
    
}
