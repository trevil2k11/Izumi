//
//  ShowCommentViewViewController.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 10.11.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import UIKit

class ShowCommentViewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var helperLib = Helper();
    var jsonLib = LibraryJSON();
    var curlSender = CurlController();
    
    var libData: [String:Any] = [:];
    var libComment: [[String:String]] = [];
    
    let paragraphStyleBold = NSMutableParagraphStyle()
    let paragraphStyleStd = NSMutableParagraphStyle()
    
    var attrsBold: [String: Any] = [:]
    var attrsStd: [String: Any] = [:]
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var sendCommentBtn: UIButton!
    @IBOutlet weak var tableComments: UITableView!
    @IBOutlet weak var commentField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        imgView.image = libData["image"] as? UIImage
        
        attrsBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSParagraphStyleAttributeName: paragraphStyleBold]
        attrsStd = [NSParagraphStyleAttributeName: paragraphStyleStd]
        
        let body = jsonLib.returnComments(self.libData["pic_id"] as! String)

        curlSender.sendData(body) { result in
            self.libComment = self.helperLib.returnDictFromJSON(result!)
            
            DispatchQueue.main.async(execute: {
                self.tableComments.reloadData();
                return
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableComments.dataSource = self
        tableComments.delegate = self
        
        helperLib.buttonDecorator(backBtn, bordered: false, alpha: 0.75)
        
        tableComments.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendComment(_ sender: UIButton) {        
        let body: String = jsonLib.returnAddComment(
            helperLib.loadUserDefaults("user_id"),
            pic_id: libData["pic_id"] as! String,
            comment: helperLib.specUnicodeCyrillic(commentField.text! as NSString) as String
        )

        self.curlSender.sendData(body) {result in

            var commentData: [[String: String]] = self.helperLib.returnDictFromJSON(result!)
            
        self.libComment.append(commentData[0])

            DispatchQueue.main.async(execute: {
                self.commentField.text = "";
                self.tableComments.reloadData();
                return
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! ShowCommentsTableViewCell
        let rowNum = (indexPath as NSIndexPath).row
        
        let attrText = NSMutableAttributedString(string: self.libComment[rowNum]["comment_author"]! + " " + self.libComment[rowNum]["dt"]! + "\n", attributes: attrsBold)
        attrText.append(NSAttributedString(string: (self.libComment[rowNum]["comment"]!), attributes: attrsStd))
        cell.textArea.attributedText = attrText.mutableCopy() as! NSAttributedString
        
        return cell;
    }
}
