//
//  WardrobeController.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 28.04.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import UIKit
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

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


protocol PictureGetter {
    var picId: Int { get set }
}

class WardrobeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let helperLib = Helper();
    let curlSender = CurlController();
    let returnJSON = LibraryJSON();
    
    fileprivate let reuseIdenifier = "WardrobeCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 1.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    var headers: [[String:String]] = []
    var libPlaces: [[String:String]] = [];
    var tng: thing!;
    var shelf: Array<thing> = [];
    var onFront: Bool = false;
    
    @IBOutlet weak var wardrobeCollectionView: UICollectionView!
    
    @IBAction func openSideMenu(_ sender: UIBarButtonItem) {
        if largePhotoIndexPath != nil {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PlaceTable") as! PlaceTableViewController
            nextViewController.selectedPictId = photoForIndexPath(largePhotoIndexPath!).imgId
            
            self.present(nextViewController, animated: true, completion: nil)
        } else {
            helperLib.showAlertMessage("err_no_pic")
        }
    }
    
    var largePhotoIndexPath : IndexPath? {
        didSet {
            var indexPaths = [IndexPath]()
            if largePhotoIndexPath != nil {
                indexPaths.append(largePhotoIndexPath!)
            }
            if oldValue != nil {
                indexPaths.append(oldValue!)
            }
            wardrobeCollectionView?.performBatchUpdates({
                self.wardrobeCollectionView?.reloadItems(at: indexPaths)
                return
            }){
                completed in
                if self.largePhotoIndexPath != nil {
                    self.wardrobeCollectionView?.scrollToItem(
                        at: self.largePhotoIndexPath!,
                        at: .centeredVertically,
                        animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKbrdWhenTapAround()
        
        wardrobeCollectionView.dataSource = self
        wardrobeCollectionView.delegate = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        
        wardrobeCollectionView.collectionViewLayout = layout
        
        let parts = returnJSON.returnUserWardrobeHeaders(helperLib.loadUserDefaults("user_id"))
        let body = returnJSON.returnUserWardrobe(helperLib.loadUserDefaults("user_id"))
        
        curlSender.sendData(parts) {result in
            self.headers = self.helperLib.returnDictFromJSON(result!)
            if self.headers.count > 0 {
            
                self.curlSender.sendData(body, completionHandler: { (result) in
                    var localDict = self.helperLib.returnDictFromJSON(result!)
                    if localDict.count > 0 {
                        for i in 0..<localDict.count {
                                let cloth: thing = thing.init(name: localDict[i]["pic_name"]!, part: localDict[i]["pic_data"]!, img: localDict[i]  ["id"]!, id: localDict[i]["pic_id"]!);
                            self.shelf.append(cloth)
                        }
                        DispatchQueue.main.async{
                            self.wardrobeCollectionView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    func reloadHeaders() {
        let parts = returnJSON.returnUserWardrobeHeaders(helperLib.loadUserDefaults("user_id"))
        
        curlSender.sendData(parts) {result in
            self.headers = self.helperLib.returnDictFromJSON(result!)
            
            DispatchQueue.main.async{
                self.wardrobeCollectionView.reloadData()
            }
        }
    }
    
    func photoForIndexPath(_ indexPath: IndexPath) -> thing {
        return helperLib.getThingsByPartname(self.shelf,partName: headers[(indexPath as NSIndexPath).section]["id"]!)[(indexPath as NSIndexPath).row]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdenifier, for: indexPath) as! WardrobeCell
        
        let bColor: UIColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.3)
        
        cell.layer.borderColor = bColor.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        
        cell.backgroundColor = UIColor.white
        
        let book: thing = helperLib.getThingsByPartname(self.shelf,partName: headers[(indexPath as NSIndexPath).section]["id"]!)[(indexPath as NSIndexPath).row]
        cell.onLoadAnimation(book.part!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return helperLib.getThingsByPartname(self.shelf, partName: headers[section]["id"]!).count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return headers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerSection", for: indexPath) as! WardrobeHeaderCollectionReusableView
        
        header.headerText.text = headers[(indexPath as NSIndexPath).section]["description"]
        
        return header;
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if largePhotoIndexPath == indexPath {
            largePhotoIndexPath = nil
        }
        else {
            largePhotoIndexPath = indexPath
        }
        return false
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func sizeToFillWidthOfSize(_ size:CGSize) -> CGSize {
        let imageSize = CGSize(width: 80, height: 80)
        var returnSize = size
        
        let aspectRatio = imageSize.width / imageSize.height
        
        returnSize.height = returnSize.width / aspectRatio
        
        if returnSize.height > size.height {
            returnSize.height = size.height
            returnSize.width = size.height * aspectRatio
        }
        
        return returnSize
    }
    
    @IBAction func returnToProfile(_ sender: UIButton) {
        if self.helperLib.loadUserDefaults("user_type") == "user" {
            self.helperLib.goToScreen("userProfile", parent: self)
        } else if self.helperLib.loadUserDefaults("user_type") == "stylist" {
            self.helperLib.goToScreen("stylistProfile", parent: self)
        }
    }
    
    @IBAction func goToConsultation(_ sender: UIButton) {
        if self.helperLib.loadUserDefaults("user_type") == "user" {
            self.helperLib.goToScreen("createPropose", parent: self)
        } else if self.helperLib.loadUserDefaults("user_type") == "stylist" {
            self.helperLib.goToScreen("stylistacceptConsultation", parent: self)
        }
    }
}

extension WardrobeController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var retWidth: CGFloat = 80.0;
        var retHeight: CGFloat = 80.0;
        
        if indexPath == largePhotoIndexPath {
            let cell = self.wardrobeCollectionView.cellForItem(at: indexPath) as! WardrobeCell
            
            if cell.imgView.image?.size.width >= collectionView.bounds.width
                || cell.imgView.image?.size.height >= collectionView.bounds.height {
                retWidth = collectionView.bounds.width - 10.0;
                retHeight = collectionView.bounds.height - 10.0;
            } else {
                retWidth = (cell.imgView.image?.size.width)!;
                retHeight = (cell.imgView.image?.size.height)!;
            }
            
            return CGSize(width: retWidth, height: retHeight)
        }
        return CGSize(width: retWidth, height: retHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
