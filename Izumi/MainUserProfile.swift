//
//  MainUserProfile.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 30.03.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import UIKit

class MainUserProfile: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    let helperLib = Helper();
    let returnJSON = LibraryJSON();
    let curlSender = CurlController();
    
    fileprivate let reuseIdenifier = "FavoriteCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 1.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    fileprivate let defaults = UserDefaults.standard
    
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var avgPoints: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var favoriteCollection: UICollectionView!
    @IBOutlet weak var avatarActivity: UIActivityIndicatorView!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var accountType: UILabel!
    @IBOutlet weak var firstLastName: UILabel!
    @IBOutlet weak var userAvatarContainer: UIView!
    
    @IBAction func logoffAction(_ sender: UIButton) {
        defaults.set(nil, forKey: "login")
        defaults.set(nil, forKey: "pwd")
        defaults.set(nil, forKey: "autoLogin")
        defaults.synchronize()
        
        helperLib.goToScreen("UserEntrance", parent: self)
    }
    
    var favoritesLib: [[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.hideKbrdWhenTapAround();
        
        helperLib.doRound(avatarView)
        helperLib.doRound(userStatus)
        helperLib.doRound(userAvatarContainer)
        
        favoriteCollection.dataSource = self
        favoriteCollection.delegate = self

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        
        favoriteCollection.collectionViewLayout = layout
        favoriteCollection.backgroundColor = UIColor.white
        
        let profile = returnJSON.returnUserProfile(helperLib.loadUserDefaults("user_id"))
        let favorites = returnJSON.returnBestPict(helperLib.loadUserDefaults("user_id"))
        
        curlSender.sendData(profile) {result in
            DispatchQueue.main.async{
                self.initUserInfo(self.helperLib.returnDictFromJSON(result!)[0])
                self.curlSender.sendData(favorites, completionHandler: { (result) in
                    self.favoritesLib = self.helperLib.returnDictFromJSON(result!)
                    DispatchQueue.main.async{
                        self.favoriteCollection.reloadData()
                    }
                })
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdenifier, for: indexPath) as! FavoritesCell
        
        let bColor: UIColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.3)
        
        cell.layer.borderColor = bColor.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        cell.backgroundColor = UIColor.white
        cell.onLoadAnimation(favoritesLib[(indexPath as NSIndexPath).row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesLib.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func initUserInfo(_ dict: [String:String]) {
        nickName.text = dict["login"]
        avgPoints.text = dict["avg_u_s"]
        ImageLoader.sharedLoader.imageForUrl(returnJSON.returnFullURL(dict["pic_data"]!)) {  (image, url) -> () in
            if image != nil {
                self.avatarView.image = self.helperLib.compressImage(image!, maxHeight: 120.0, maxWidth: 120.0)
            }
            self.avatarActivity.stopAnimating();
        }
    }
}
