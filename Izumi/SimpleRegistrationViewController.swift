//
//  RegistrationStylistController.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 04.07.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import UIKit
import MobileCoreServices

class SimpleRegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate {
    
    let helperLib = Helper();
    let LibJSON = LibraryJSON();
    let curlSender = CurlController();
    //Step1 objects
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var isStylist: CheckBox!
    
    @IBOutlet weak var nextButtonStep1: UIButton!
    @IBOutlet weak var backButtonToStep1: UIButton!
    
    //Step2 objects
    @IBOutlet weak var avatarPhotoBtn: UIButton!
    @IBOutlet weak var diplomaPhotoBtn: UIButton!
    
    @IBOutlet weak var avatarGalleryBtn: UIButton!
    @IBOutlet weak var diplomaGalleryBtn: UIButton!
    
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var diplomaImgView: UIImageView!
    
    @IBOutlet weak var registrationFinishBtn: UIButton!
    
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var diplomaView: UIView!
    
    var newMedia: Bool?
    var currentImgView: UIImageView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.setGradient(viewController: self)
        super.viewWillAppear(animated)
        
        if (self.restorationIdentifier == "RegistrationStep1") {
            helperLib.textFieldDecorator(
                nicknameField,
                passwordField
            )
            helperLib.buttonDecorator(nextButtonStep1)
        }
        
        if self.restorationIdentifier == "RegistrationStep2" {
            if helperLib.loadUserDefaults("isStylist") == "0" {
                diplomaView.isHidden = true
                helperLib.doRound(avatarView, needBorder: false)
                avatarImgView.image = helperLib.loadImageFromLib("avatarRegImage")
            } else {
                helperLib.doRound(avatarView, diplomaView, needBorder: false)
                avatarImgView.image = helperLib.loadImageFromLib("avatarRegImage")
                diplomaImgView.image = helperLib.loadImageFromLib("diplomaRegImage")
            }
            helperLib.buttonDecorator(registrationFinishBtn, backButtonToStep1)
            helperLib.doRound(avatarImgView, diplomaImgView)
        }
    }
    
    @IBAction func backToStep1(_ sender: Any) {
        if (avatarImgView.image != nil) {
            helperLib.savePicToData(avatarImgView.image!, keyStr: "avatarRegImage")
        }
        if (diplomaImgView.image != nil) {
            helperLib.savePicToData(diplomaImgView.image!, keyStr: "diplomaRegImage")
        }
        helperLib.goToScreen("RegistrationStep1", parent: self)
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
        
        if self.restorationIdentifier == "RegistrationStep1" {
            nicknameField.text = helperLib.loadUserDefaults("login").isEmpty == false ? helperLib.loadUserDefaults("login") : ""
            
            isStylist.isSelected = true
        } else if self.restorationIdentifier == "RegistrationStep2" {
            avatarImgView.image = helperLib.loadUserDefaults("avatar").isEmpty == false ? helperLib.loadImageFromLib("avatar") : nil
            if helperLib.loadUserDefaults("isStylist") == "1" {
                diplomaImgView.image = helperLib.loadUserDefaults("diploma").isEmpty == false ? helperLib.loadImageFromLib("diploma") : nil
            }
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
        if self.restorationIdentifier == "RegistrationStep1" {
            let allCheck: Int = checkEmpty(nicknameField) +
                checkEmpty(passwordField)
            if allCheck == 0 {
                helperLib.clearStylistDefaultInRegistration();
                helperLib.saveUserDefaults(nicknameField.text!, key: "login")
                helperLib.saveUserDefaults(helperLib.md5(passwordField.text!), key: "pwd")
                helperLib.saveUserDefaults(String(isStylist.isSelected), key: "isStylist")
                helperLib.goToScreen("RegistrationStep2", parent: self)
            }
        }
    }
    
    @IBAction func finishRegistration(_ sender: UIButton) {
        if avatarImgView.image != nil &&
            (diplomaImgView.image != nil && Int(helperLib.loadUserDefaults("isStylist"))! == 1) {
            let keyVal = helperLib.returnSimpleKeyVal();
            var params: [String:String] = [:];
            
            for (key,val) in keyVal {
                params[key] = helperLib.loadUserDefaults(val);
            }
            
            let body = LibJSON.returnCreateUser(params)
            
            curlSender.sendData(body, completionHandler: { (result) in
                let data = result!.data(using: String.Encoding.utf8.rawValue)
                var json = JSON(data: data!)
                OperationQueue.main.addOperation {
                    print(json)
                    if Int(json["data"].stringValue) == 1 {
                        self.helperLib.goToScreen("MainLibrary", parent: self)
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
