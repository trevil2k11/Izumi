//
//  Helper.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 25.03.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Helper {
    fileprivate var errStack = ErrorLibrary();
    var managedContext = DataController().managedObjectContext
    
    let defaults = UserDefaults.standard
    
    struct jsonToSend {
        var cntrlName: String?
        var actionName: String?
        var params: Dictionary<String,String>
        
        func returnJsonString()->String{
            var defaultString = "{'controller':'" + cntrlName! + "','action':'" + actionName! + "'"
            
            for item in params {
                defaultString += ",'"+item.0+"':'"+item.1+"'"
            }
            return defaultString + "}"
        }
    }
    
    func initJsonToSend(_ cntrlName: String, actionName: String, params: Dictionary<String,String>)->String{
        return jsonToSend(cntrlName: cntrlName, actionName: actionName, params: params).returnJsonString();
    }
    
    func showAlertMessage(_ errName: String) {
        let alertMessage = UIAlertView();
        alertMessage.title = errStack.returnErrTitle(errName);
        alertMessage.message = errStack.returnErrDescr(errName);
        alertMessage.addButton(withTitle: "Ok");
        
        alertMessage.show();
    }
    
    func showDataMessage(_ data: String) {
        let alertMessage = UIAlertView();
        alertMessage.title = "DATA"
        alertMessage.message = data
        alertMessage.addButton(withTitle: "Ok");
        
        alertMessage.show();
    }
    
    func showBuyMessage() {
        let shopMessage = UIAlertView();
        shopMessage.title = "Совершение покупки"
        shopMessage.message = "Вы действительно хотите совершить покупку?"
        shopMessage.addButton(withTitle: "Да")
        shopMessage.addButton(withTitle: "Нет")
        
        shopMessage.show()
    }
    
    func returnCyrillicAndJsoned(_ input : NSString) -> NSString{
        let transform = "Any-Hex/Java"
        var convertedString = input.mutableCopy() as! NSMutableString
        CFStringTransform(convertedString, nil, transform as NSString, true)
        convertedString = ((convertedString as String).replacingOccurrences(of: "\"", with: "\\\"") as NSString).mutableCopy() as! NSMutableString;
        
        return convertedString;
    }
    
    func specUnicodeCyrillic(_ input: NSString) -> NSString {
        let transform = "Any-Hex/Java"
        var convertedString = input.mutableCopy() as! NSMutableString
        CFStringTransform(convertedString, nil, transform as NSString, false)
        convertedString = ((convertedString as String).replacingOccurrences(of: "\"", with: "\\\"") as NSString).mutableCopy() as! NSMutableString;
        return convertedString;
    }
    
    func getResFromJSON(_ input: NSString)->String{
        let data = input.data(using: String.Encoding.utf8.rawValue);
        var json = JSON(data: data!)
        
        return json["data"][0]["res"].stringValue;
    }
    
    func goToScreen(_ nextScreen: String, parent: UIViewController)->Void{
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: nextScreen)
        parent.present(nextViewController, animated:true, completion:nil)
    }
    
    func saveData(_ data: String, key: String) {
        let person = NSEntityDescription.insertNewObject(forEntityName: "JSONData", into: managedContext) as! JSONData
        person.setValue(data, forKey: key)
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func loadData(_ key: String)->String {
        var returnString: String!;
        
        let dataFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "JSONData")
        do {
            let resultSet = try managedContext.fetch(dataFetch) as! [JSONData]
            if resultSet.count > 0 {
                returnString = String(describing: resultSet.first!.value(forKey: key))
            } else {
                returnString = "";
            }
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
        return (returnString)!;
    }
    
    func clearCoreData()->Void {
        let dataFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "JSONData")
        do {
            let fetchedData = try managedContext.fetch(dataFetch) as! [JSONData]
            if fetchedData.count > 0 {
                for result: AnyObject in fetchedData{
                    managedContext.delete(result as! NSManagedObject)
                }
                try managedContext.save()
            }
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    func md5(_ input: String)->String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let data = input.data(using: String.Encoding.utf8) {
            CC_MD5((data as NSData).bytes, CC_LONG(data.count),&digest)
        }
        var digestHex = "";
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH){
            digestHex += String(format: "%02x",digest[index])
        }
        
        return digestHex
    }
    
    func saveUserDefaults(_ data: String, key: String) {
        defaults.set(data, forKey: key)
        defaults.synchronize()
    }
    
    func saveUserPictureArrayDefaults(_ data: [UIImage], key: String) {
        defaults.set(data, forKey: key)
        defaults.synchronize()
    }
    
    func loadUserDefaults(_ key: String)->String{
        var result: String?
        if let returnString = defaults.string(forKey: key) {
            result = returnString
        } else {
            result = ""
        }
        return result!
    }
    
    func loadUserPictureDefaults(_ key: String)->[UIImage]{
        return defaults.object(forKey: key) as! [UIImage]
    }
    
    func clearUserDefaultsByKey(_ key: String) {
        defaults.set(nil, forKey: key)
    }
    
    func clearUserDefaultsInRegistration() {
        let noCheck: [String:String] = self.returnKeyValNoCheck()
        let withCheck: [String:String] = self.returnKeyValCheck()
        
        for (key,val) in noCheck {
            defaults.set(nil, forKey: key)
            defaults.set(nil, forKey: val)
        }
        
        for (key,val) in withCheck {
            defaults.set(nil, forKey: key)
            defaults.set(nil, forKey: val)
        }
        defaults.synchronize();
    }
    
    func clearStylistDefaultInRegistration() {
        let keyVal: [String:String] = self.returnStylistKeyVal()
        
        for (key,val) in keyVal {
            defaults.set(nil, forKey: key)
            defaults.set(nil, forKey: val)
        }
    }
    
    func returnDictFromJSON(_ result: NSString)->[[String:String]] {
        let data = result.data(using: String.Encoding.utf8.rawValue);
        var json = JSON(data: data!)
        var returnArray: [[String:String]] = [];
        
        if json["data"].arrayValue.count > 0 {
            for i in 0..<json["data"].arrayValue.count {
                var post = [String:String]();
                for (key, object) in json["data"][i] {
                    post[key] = object.stringValue
                }
                returnArray.append(post)
            }
        }
        
        return returnArray;
    }
    
    func loadImageFromLib(_ imgName: String) -> UIImage{
        let dataDecoded:Data = Data(base64Encoded: loadUserDefaults(imgName), options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedimage:UIImage = UIImage(data: dataDecoded)!
        return decodedimage
    }
    
    func savePicToData(_ img: UIImage, keyStr: String) {
        let imageData: Data = UIImageJPEGRepresentation(img, 1.0)!;
        let savePict = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        saveUserDefaults(savePict, key: keyStr)
    }
    
    func compressImageAndStore(_ img: UIImage, keyStr: String) {
        savePicToData(compressImage(img), keyStr: keyStr)
    }
    
    func compressImage(_ img: UIImage, maxHeight: CGFloat = 640.0, maxWidth: CGFloat = 480.0) -> UIImage {
        var actHeight: CGFloat = img.size.height
        var actWidth: CGFloat = img.size.width
        
        var imgRatio: CGFloat = actHeight/actWidth
        let maxRatio: CGFloat = maxHeight/maxWidth
        
        if actHeight > maxHeight || actWidth > maxWidth {
            if imgRatio < maxRatio {
                imgRatio = maxHeight/actHeight
                actWidth = imgRatio * actWidth
                actHeight = maxHeight
            } else if imgRatio > maxRatio {
                imgRatio = maxWidth/actWidth
                actHeight = imgRatio * actHeight
                actWidth = maxWidth
            } else {
                actHeight = maxHeight
                actWidth = maxWidth
            }
        }
        
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: actWidth, height: actHeight)
        UIGraphicsBeginImageContext(rect.size)
        img.draw(in: rect)
        let retImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()

        return retImg!
    }
    
    func percentEscapeString(_ string: String) -> String {
        return CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, string as CFString!, nil, ":/?@!$&'()*+,;=" as CFString!, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
    
    func replaceEscapeString(_ string: String) -> String {
        return CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, string as CFString!, ":/?@!$&'()*+,;=" as CFString!, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
    
    
    
    func getThingsByPartname(_ shelf: Array<thing>, partName: String) -> Array<thing> {
        var retArray: Array<thing> = []
        if shelf.count > 0 {
            for item in 0..<shelf.count {
                if shelf[item].image == partName {
                    retArray.append(shelf[item])
                }
            }
        }
        return retArray
    }
    
    func retCountByPartName(_ shelf:Array<thing>, partName: String) -> Int {
        var retCount: Int = 0;
        if shelf.count > 0 {
            for item in 0..<shelf.count {
                if shelf[item].part == partName {
                    retCount += 1;
                }
            }
        }
        return retCount
    }
    
    func returnNSAttrStringWithStdFormat(_ text: String) -> NSMutableAttributedString {
        let paragraphStyleStd = NSMutableParagraphStyle()
        paragraphStyleStd.alignment = NSTextAlignment.justified
        let attrsStd = [NSParagraphStyleAttributeName: paragraphStyleStd]
        
        return NSMutableAttributedString(string: text, attributes: attrsStd)
    }
    
    func returnKeyValCheck() -> [String:String] {
        return ["comment":"target","hair":"hair","skin":"skin","brown":"brown","venousColor":"venousColor",
                "eyes":"eyes","eyesAdd":"eyesAdd","place":"place","fullPicture":"fullPicture",
                "avatarPic":"avatarPic"];
    }
    
    func returnKeyValNoCheck() -> [String:String] {
        return ["login":"login","pwd":"pwd","email":"email","dt_birth":"dateBirth",
                "sex":"sex","typeUp":"UpperBody","typeMidUp":"MidBodyUp",
                "typeMidDown":"MidBodyBot","typeBottom":"BottomBody"];
    }
    
    func returnStylistKeyVal() -> [String:String] {
        return ["login":"login","pwd":"pwd","email":"email","fio":"fio","sex":"sex",
                "dateBirth":"dateBirth","education":"education",
                "expirience":"expirience","projects":"projects",
                "avatar":"avatar","diploma":"diploma"];
    }
    
    func returnBodyUpLib() -> [String] {
        return ["UpperBodyLeft","UpperBodyMid","UpperBodyRight"];
    }
    
    func returnMidUpperLib() -> [String] {
        return ["MidBodyUpLeft","MidBodyUpMid","MidBodyUpRight"];
    }
    
    func returnMidBottomLib() -> [String] {
        return ["MidBodyBotLeft","MidBodyBotMid","MidBodyBotRight"];
    }
    
    func returnBodyBottomLib() -> [String] {
        return ["BottomBodyLeft","BottomBodyMid","BottomBodyRight"];
    }
    
    func returnFullBody() -> [[String]] {
        return [self.returnBodyUpLib(),self.returnMidUpperLib(),self.returnMidBottomLib(),self.returnBodyBottomLib()]
    }
    
    func returnBodyKeys() -> [String] {
        return ["UpperBody","MidBodyUp","MidBodyBot","BottomBody"]
    }
    
    func returnSkin() -> [String] {
        return ["Фарфоровая, светлая","Светлая с оливковым оттенком",
                "Светлая с персиковым оттенком","Сильно смуглая,плотная"]
    }
    
    func returnHair() -> [String] {
        return ["От светлого до темного с зол. оттенком",
                "От светлого до темного без зол. оттенка",
                "Брюнет","Блонд","Рыжий","Седой","Белый"]
    }
    
    func returnBrown() -> [String] {
        return ["Быстро загораю с желтоватым оттенком",
                "Быстро загораю с красновато-коричневым оттенком оттенком",
                "Легко обгораю с красным оттенком","Не загораю"]
    }
    
    func returnVenous() -> [String] {
        return ["Голубоватый оттенок","Зеленоватый оттенок"]
    }
}
