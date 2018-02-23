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
import Photos

class AddPicture: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate {
    
    typealias NSErrorPointer = AutoreleasingUnsafeMutablePointer<NSError?>
    
    var newMedia: Bool?
    let helperLib = Helper();
    let curlSender = CurlController();
    let retJSON = LibraryJSON();
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var beckButton: UIButton!
    
    @IBOutlet weak var uiviewForLibrary: UIView!
    override func viewDidLoad() {
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        super.viewDidLoad()
        self.view.backgroundColor = helperLib.getMainColor()
        self.hideKbrdWhenTapAround();
        setupPhotos();
    }
    
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
    
    @IBAction func backToPreviousScreen(_ sender: Any) {
        helperLib.goToScreen(helperLib.loadUserDefaults("lastViewController"), parent: self)
    }
    
    @IBAction func uploadPicture(_ sender: UIButton) {
//        if imageView.image != nil {
//            let imageData: Data = UIImageJPEGRepresentation(helperLib.compressImage(imageView.image!), 1.0)!;
//            let savePict = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//            let uploadPic = helperLib.percentEscapeString(savePict)
//            
//            var params: [String:String] = [:];
//            params["user_id"] = helperLib.loadUserDefaults("user_id");
//            params["pic_data"] = uploadPic;
//            
//            let sendStr = retJSON.returnUploadPicture(params);
//            
//            curlSender.sendData(sendStr, completionHandler: { result in
//                OperationQueue.main.addOperation {
//                    if Int(self.helperLib.getResFromJSON(result!)) == 1 {
//                        self.imageView.image = nil;
//                    } else {
//                        self.helperLib.showAlertMessage("err_pic", viewControl: self)
//                    }
//                }
//            })
//        }
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "powerId")
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.delegate = self
        present(vc, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
        let btnDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(AddPicture.dismiss as (AddPicture) -> () -> ()))
        navigationController.topViewController?.navigationItem.rightBarButtonItem = btnDone
        return navigationController
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
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
    
    var favoritesLib: [UIImage] = []
    
    func setupPhotos() {
        let imageManager = PHImageManager()
        
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status
            {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]

                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                for i in 0..<allPhotos.count {
                    let asset = allPhotos.object(at: i)
                    
                    let imSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                    let options = PHImageRequestOptions()
                    options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
    
                    imageManager.requestImage(
                        for: asset,
                        targetSize: imSize,
                        contentMode: .aspectFill,
                        options: options,
                        resultHandler: { (UIImage, info) in
                            self.favoritesLib.append(UIImage!)
                    })
                    self.collectionView.reloadData();
                }
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! PhotoCell
        
        let bColor: UIColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.3)
        
        cell.layer.borderColor = bColor.cgColor
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 3
        cell.backgroundColor = UIColor.white
        cell.imgView.image = favoritesLib[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.imageView.image = favoritesLib[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width/4, height: self.collectionView.bounds.width/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesLib.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
