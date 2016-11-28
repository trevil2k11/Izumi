//
//  OfferCreationViewController.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 23.08.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import UIKit
import MobileCoreServices

class OfferCreationViewController:
        UIViewController
//    ,
//        UICollectionViewDelegate,
//        UICollectionViewDataSource,
//        UINavigationControllerDelegate,
//        UIImagePickerControllerDelegate
{

    @IBOutlet weak var orderCollection: UICollectionView!
    @IBOutlet weak var addPicBtn: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var comment: UITextView!
    
    fileprivate var imageForOffer: [UIImage] = []
    fileprivate let reuseIdenifier = "AddPhoto"
    fileprivate let sectionInsets = UIEdgeInsets(top: 1.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    var currentImageView = UIImageView();
    
    var indexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKbrdWhenTapAround()

//        if (self.restorationIdentifier == "showPictures") {
//            orderCollection.dataSource = self
//            orderCollection.delegate = self
//            
//            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//            layout.sectionInset = sectionInsets
//            layout.minimumInteritemSpacing = 5
//            layout.minimumLineSpacing = 10
//            
//            orderCollection.collectionViewLayout = layout
//            
//            panelForSending.hidden = true;
//            
//            if helperLib.loadUserPictureDefaults("imageArrayForOffer").count > 0 {
//                imageForOffer = helperLib.loadUserPictureDefaults("imageArrayForOffer")
//            }
//        
//            if helperLib.loadUserDefaults("commentsInOffer").isEmpty == false {
//                comment.attributedText =
//                    helperLib.returnNSAttrStringWithStdFormat(
//                            helperLib.loadUserDefaults("commentsInOffer")
//                    )
//            }
//        }
    }
    
    @IBAction func backToLibrary(_ sender: UIButton) {
//        helperLib.clearUserDefaultsByKey("imageArrayForOffer")
//        helperLib.clearUserDefaultsByKey("commentsInOffer")
//        
//        helperLib.goToScreen("Library", parent: self)
    }
    @IBAction func goToOfferCollection(_ sender: UIButton) {
//        if (currentImageView.image != nil) {
//            imageForOffer.append(currentImageView.image!)
//            
//            currentImageView.image = nil
//            
//            helperLib.goToScreen("showPictures", parent: self)
//        }
    }
    @IBOutlet weak var panelForSending: UIView!
    @IBAction func preparedForSending(_ sender: UIButton) {
//        if (self.restorationIdentifier == "showPictures"
//            && imageForOffer.count > 0
//            && comment.attributedText.string.isEmpty == false) {
//            panelForSending.hidden = false;
//        }
    }
    
//    var newMedia: Bool?
//    let helperLib = Helper();
//    let curlSender = CurlController();
//    let retJSON = LibraryJSON();
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdenifier, forIndexPath: indexPath) as! CustomOfferCollectionViewCell
//        
//        let bColor: UIColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.3)
//        
//        cell.delButton.addTarget(
//            self,
//            action: #selector(OfferCreationViewController.removePicture(_:)),
//            forControlEvents: .TouchUpInside
//        )
//        
//        if self.imageForOffer.count >= indexPath.row + 1 {
//            cell.imgView.image = self.imageForOffer[indexPath.row]
//        }
//        
//        cell.layer.borderColor = bColor.CGColor
//        cell.layer.borderWidth = 0.5
//        cell.layer.cornerRadius = 3
//                
//        cell.backgroundColor = UIColor.whiteColor()
//        
//        return cell
//    }
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imageForOffer.count > 0 ? imageForOffer.count : 1
//    }
//    
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    @IBAction func cameraTakePicture() {
//        if UIImagePickerController.isSourceTypeAvailable(
//            UIImagePickerControllerSourceType.Camera) {
//            
//            let imagePicker = UIImagePickerController()
//            
//            imagePicker.delegate = self
//            imagePicker.sourceType =
//                UIImagePickerControllerSourceType.Camera
//            imagePicker.mediaTypes = [kUTTypeImage as String]
//            imagePicker.allowsEditing = false
//            
//            self.presentViewController(imagePicker, animated: true, completion: nil)
//            newMedia = true
//        } else {
//            helperLib.showAlertMessage("err_no_cam")
//        }
    }
    
    @IBAction func libraryTakePicture(_ sender: AnyObject?) {
//        if UIImagePickerController.isSourceTypeAvailable(
//            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
//            let imagePicker = UIImagePickerController()
//            
//            imagePicker.delegate = self
//            imagePicker.sourceType =
//                UIImagePickerControllerSourceType.PhotoLibrary
//            imagePicker.mediaTypes = [kUTTypeImage as String]
//            imagePicker.allowsEditing = false
//            self.presentViewController(imagePicker, animated: true,
//                                       completion: nil)
//            newMedia = false
//        } else {
//            helperLib.showAlertMessage("err_no_lib")
//        }
    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        
//        let mediaType = info[UIImagePickerControllerMediaType] as! String
//        
//        self.dismissViewControllerAnimated(true, completion: nil)
//        
//        if mediaType.containsString(kUTTypeImage as String) {
//            let image = info[UIImagePickerControllerOriginalImage]
//                as! UIImage
//            
//            imageForOffer.append(image)
//            
//            if (newMedia == true) {
//                UIImageWriteToSavedPhotosAlbum(image, self,
//                                               #selector(AddPicture.image(_:didFinishSavingWithError:contextInfo:)), nil)
//            } else if mediaType.containsString(kUTTypeMovie as String) {
//                // Code to support video here
//            }
//            
//        }
//    }
//    
//    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
//        if error != nil {
//            helperLib.showAlertMessage("err_save")
//        }
//    }
//    
//    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        helperLib.showDataMessage(String(indexPath.row))
//    }
//    
//    func removePicture(sender: UIButton?) {
//        let point : CGPoint = sender!.convertPoint(CGPointZero, toView:orderCollection!)
//        let indexPath = orderCollection!.indexPathForItemAtPoint(point)
//        
//        self.orderCollection.deleteItemsAtIndexPaths([indexPath!])
//        imageForOffer.removeAtIndex(indexPath!.item)
//    }
//    
//    @IBAction func addAnotherPicture(sender: UIButton) {
//        if imageForOffer.count > 0 {
//            helperLib.saveUserPictureArrayDefaults(imageForOffer, key: "imageArrayForOffer")
//        }
//        if comment.attributedText.length > 0 {
//            helperLib.saveUserDefaults(comment.attributedText.string, key: "commentsInOffer")
//        }
//        
//        helperLib.goToScreen("createPropose", parent: self)
//    }
//    
//    
}

//extension OfferCreationViewController : UICollectionViewDelegateFlowLayout {
//    func collectionView(collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
//        let retWidth: CGFloat = 120.0;
//        let retHeight: CGFloat = 120.0;
//        
////        if indexPath == largePhotoIndexPath {
////            let cell = self.wardrobeCollectionView.cellForItemAtIndexPath(indexPath) as! WardrobeCell
////            
////            if cell.imgView.image?.size.width >= collectionView.bounds.width
////                || cell.imgView.image?.size.height >= collectionView.bounds.height {
////                retWidth = collectionView.bounds.width - 10.0;
////                retHeight = collectionView.bounds.height - 10.0;
////            } else {
////                retWidth = (cell.imgView.image?.size.width)!;
////                retHeight = (cell.imgView.image?.size.height)!;
////            }
////            
////            return CGSize(width: retWidth, height: retHeight)
////        }
//        return CGSize(width: retWidth, height: retHeight)
//    }
//    
//    func collectionView(collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//}
