//
//  UserInfoController.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 11.08.17.
//  Copyright © 2017 Ilya Kosolapov. All rights reserved.
//

import UIKit

class UserInfoController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let nameMap = ["Фото профиля", "Личная информация", "О себе", "Фигура"]
    let identifierMap = ["avatarView", "personalView", "aboutMeView", "figureView"]

    let helperLib = Helper()
    
    @IBOutlet weak var userInfoOptions: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = helperLib.getMainColor()
        userInfoOptions.dataSource = self
        userInfoOptions.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return identifierMap.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        helperLib.goToScreen(identifierMap[indexPath.row], parent: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.userInfoOptions.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = self.nameMap[indexPath.row]
        
        return cell
    }
}
