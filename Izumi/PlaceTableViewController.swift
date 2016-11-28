//
//  PlaceTableView.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 26.06.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import UIKit

class PlaceTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let helperLib = Helper();
    let curlSender = CurlController();
    let jsonLib = LibraryJSON();
    
    var libArray: [[String:String]] = [];
    var selectedPictId: String?;
    
    @IBOutlet weak var placeTable: UITableView!
    
    @IBAction func returnToWardrobe(_ sender: UIButton) {
        helperLib.goToScreen("Wardrobe", parent: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeTable.dataSource = self
        placeTable.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let body:String = jsonLib.returnPlaces();
        curlSender.sendData(body) {result in
            self.libArray = self.helperLib.returnDictFromJSON(result!)
            
            if self.libArray.count > 0 {
                DispatchQueue.main.async(execute: {
                    self.placeTable.reloadData();
                })
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
        cell.configure(libArray[(indexPath as NSIndexPath).row]);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let body = jsonLib.returnChangePlace(selectedPictId!, place_id: libArray[(indexPath as NSIndexPath).row]["id"]!)
        curlSender.sendData(body) { (result) in
            self.helperLib.goToScreen("Wardrobe", parent: self)
        }
    }
}
