//
//  LibraryControllerSubscriptions.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 29.11.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import Foundation
import UIKit

class LibraryControllerSubscriptions: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableLib: UITableView!
    
    @IBAction func profileReturn(_ sender: UIButton) {
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
    
    let curlSender = CurlController();
    let helperLib = Helper();
    let jsonLib = LibraryJSON();
    
    let refreshControl = UIRefreshControl()
    var libArray: [[String:String]] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(LibraryControllerMain.refresh(_:)), for: UIControlEvents.valueChanged)
        
        tableLib.dataSource = self
        tableLib.delegate = self
        
        tableLib.addSubview(refreshControl)
    }
    
    func refresh(_ sender:AnyObject) {
        refreshBegin({(x:Int) -> () in
            self.tableLib.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
    
    func refreshBegin(_ refreshEnd:@escaping (Int) -> ()) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let lastDate: String = self.libArray.count == 0 ? "2016-01-01 00:00:00" : String(describing: self.libArray[0]["date_upload"]);
            let body:String = self.jsonLib.returnLibNew(lastDate)
            self.curlSender.sendData(body) {result in
                let localArray: [[String:String]] = self.helperLib.returnDictFromJSON(result!)
                if localArray.count > 0 {
                    for obj: [String:String] in localArray {
                        self.libArray.insert(obj, at: 0)
                    }
                }
                
                DispatchQueue.main.async {
                    refreshEnd(0)
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "libCell", for: indexPath) as! LibraryCellTableViewCell
        cell.configure(self.libArray[(indexPath as NSIndexPath).row])
        return cell;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let body:String = jsonLib.returnLib(String(self.accessibilityElementCount()), upper_id: String(self.accessibilityElementCount()+5))
        curlSender.sendData(body) {result in
            self.libArray = self.helperLib.returnDictFromJSON(result!)
            if self.libArray.count > 0 {
                DispatchQueue.main.async(execute: {
                    self.tableLib.reloadData();
                    return
                })
            }
        }
    }
}
