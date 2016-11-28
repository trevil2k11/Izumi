//
//  InnerShop.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 01.07.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import UIKit

class InnerShop: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let helperLib = Helper();
    
    @IBOutlet weak var shopTable: UITableView!
    
    let subscribes: Array<Array<String>> = [["Увеличить до 10 коснультаций в неделю","49.00 р."],
                                            ["Увеличить до 15 коснультаций в неделю","69.00 р."],
                                            ["Увеличить до 20 коснультаций в неделю","99.00 р."],
                                            ["Увеличить количество консультаций на 5 в неделю в течение месяца","129.00 р."],
                                            ["Увеличить количество консультаций на 10 в неделю в течение месяца","149.00 р."]];
    let oneTimeBuy: Array<Array<String>> = [["10 изображений на консультацию","49.00 р."],
                                            ["15 изображений на консультацию","69.00 р."],
                                            ["Возможность получать онлайн-консультации","199.00 р."]];
    var sum: Array<Array<Array<String>>> = [];
    let headers: Array<String> = ["Подписки", "Разовые покупки"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopTable.delegate = self
        shopTable.dataSource = self
        
        sum.append(subscribes)
        sum.append(oneTimeBuy)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sum[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = sum[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row][0]
        cell.detailTextLabel?.text = sum[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row][1]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        helperLib.showBuyMessage();
    }
}
