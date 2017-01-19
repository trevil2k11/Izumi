//
//  AddPicture.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 23.05.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class AddPicture: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    typealias NSErrorPointer = AutoreleasingUnsafeMutablePointer<NSError?>
    
    var newMedia: Bool?
    let helperLib = Helper();
    let curlSender = CurlController();
    let retJSON = LibraryJSON();
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKbrdWhenTapAround();
    }
    
    @IBOutlet weak var pic_name: UITextField!
    @IBOutlet weak var pic_description: UITextField!
    
    @IBOutlet weak var cameraTake: UIBarButtonItem!
    @IBOutlet weak var LibraryTake: UIBarButtonItem!
    @IBOutlet weak var uploadBtn: UIButton!
    
    @IBAction func returnToProfile(_ sender: UIButton) {
        if self.helperLib.loadUserDefaults("user_type") == "user" {
            self.helperLib.goToScreen("userProfile", parent: self)
        } else if self.helperLib.loadUserDefaults("user_type") == "stylist" {
            self.helperLib.goToScreen("stylistProfile", parent: self)
        }
    }
    
    @IBAction func goToConsultation(_ sender: UIButton) {
        if self.helperLib.loadUserDefaults("user_type") == "user" {
            self.helperLib.goToScreen("userSelectConsultation", parent: self)
        } else if self.helperLib.loadUserDefaults("user_type") == "stylist" {
            self.helperLib.goToScreen("stylistacceptConsultation", parent: self)
        }
    }
    
    @IBAction func uploadPicture(_ sender: UIButton) {
        if imageView.image != nil {
            let imageData: Data = UIImageJPEGRepresentation(helperLib.compressImage(imageView.image!), 1.0)!;
            let savePict = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            let uploadPic = helperLib.percentEscapeString(savePict)
            
            var params: [String:String] = [:];
            params["user_id"] = helperLib.loadUserDefaults("user_id");
            params["pic_name"] = pic_name.text;
            params["descr"] = pic_description.text;
            params["pic_data"] = uploadPic;
            
            let sendStr = retJSON.returnUploadPicture(params);
            
            curlSender.sendData(sendStr, completionHandler: { result in
                OperationQueue.main.addOperation {
                    if Int(self.helperLib.getResFromJSON(result!)) == 1 {
                        self.imageView.image = nil;
                        self.pic_name.text = "";
                        self.pic_description.text = "";
                    } else {
                        self.helperLib.showAlertMessage("err_pic", viewControl: self)
                    }
                }
            })
        }
        
        
    }
    
    @IBAction func cameraTakePicture(_ sender: UIBarButtonItem) {
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
    
    @IBAction func libraryTakePicture(_ sender: UIBarButtonItem) {
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
            
            imageView.image = image
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                                               #selector(AddPicture.image(_:didFinishSavingWithError:contextInfo:)), nil)
            } else if mediaType.contains(kUTTypeMovie as String) {
                // Code to support video here
            }
            
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSErrorPointer?, contextInfo:AnyObject) {
        if error != nil {
            helperLib.showAlertMessage("err_save", viewControl: self)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
