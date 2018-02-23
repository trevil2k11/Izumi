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
    
    func showAlertMessage(_ errName: String, viewControl: UIViewController) {
        let alertMessage =
            UIAlertController(
                title: errStack.returnErrTitle(errName),
                message: errStack.returnErrDescr(errName),
                preferredStyle: .alert
            )
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertMessage.addAction(OKAction)
        
        viewControl.present(alertMessage, animated: true, completion:nil)
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
    
    func showNewMessage(title: String, description: String, viewControl: UIViewController){
        let alertMessage = UIAlertController(title: title, message: description, preferredStyle: .actionSheet)
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertMessage.addAction(OKAction)
        
        viewControl.present(alertMessage, animated: true, completion: nil)
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
    
    func getMainColor()->UIColor {
        return UIColor.init(colorLiteralRed: 94/255, green: 67/255, blue: 191/255, alpha: 1)
        //+5/-3/-6
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
    
    func saveEyeColor(_ data: UIColor, key: String) {
        defaults.set(data, forKey: key)
        defaults.synchronize()
    }
    
    func saveUserPictureArrayDefaults(_ data: [UIImage], key: String) {
        defaults.set(data, forKey: key)
        defaults.synchronize()
    }
    
    func loadEyeColor(key: String) -> UIColor {
        if let result:UIColor = defaults.object(forKey: key) as! UIColor! {
            return result
        } else {
            return UIColor.gray
        }
    }
    
    func loadDefaultOrChecked(_ key: String)->Bool {
        var result: Bool = false
        
        if let returnValue = defaults.bool(forKey: key) as? Bool {
            result = returnValue
        }
        return result
    }
    
    func setChecked(_ data: Bool, key: String) {
        defaults.set(data, forKey: key)
        defaults.synchronize()
    }
    
    func loadUserDefaults(_ key: String, defaultValue: String = "")->String{
        var result: String?
        if let returnString = defaults.string(forKey: key) {
            result = returnString
        } else {
            result = defaultValue
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
    
    func clearSimpleDefaultInRegistration() {
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
    
    func compressImage(_ img: UIImage, maxHeight: CGFloat = 1024.0, maxWidth: CGFloat = 768.0) -> UIImage {
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
    
    func buttonDecorator(_ buttons: UIButton..., bordered: Bool = true) {
        for button in buttons {
//            button.backgroundColor = UIColor.init(colorLiteralRed: 94/255, green: 67/255, blue: 191/255, alpha: 1)
            button.backgroundColor = .clear
            if (bordered) {
                button.layer.cornerRadius = 0
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.white.cgColor
            }
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
        }
    }
    
    func textFieldDecorator(_ textFields: UITextField..., bordered: Bool = true) {
        for textField in textFields {
            textField.backgroundColor = .clear
            textField.font =  UIFont(name: "Muller", size: 20.0)
            if (bordered) {
                textField.layer.cornerRadius = 0
                textField.layer.borderWidth = 1
                textField.layer.borderColor = UIColor.white.cgColor
            }
            textField.textColor = UIColor.white
        }
    }
    
    func textViewDecorator(_ textViews: UITextView..., bordered: Bool = true) {
        for textView in textViews {
            textView.backgroundColor = .clear
            textView.font =  UIFont(name: "Muller", size: 20.0)
            if (bordered) {
                textView.layer.cornerRadius = 6
                textView.layer.borderWidth = 1
                textView.layer.borderColor = UIColor.white.cgColor
            }
            textView.textColor = UIColor.white
        }
    }
    
    func doRound(_ objects: UIImageView...) {
        for object in objects {
            object.layer.cornerRadius = object.frame.size.width / 2;
            object.clipsToBounds = true;
        }
    }
    
    func doRound(_ objects: UIView..., needBorder: Bool = true) {
        for object in objects {
            object.layer.cornerRadius = object.frame.size.width / 2;
            object.clipsToBounds = true;
            
            if (needBorder) {
                object.layer.borderWidth = 1.0;
                object.layer.borderColor = UIColor.magenta.cgColor;
            }
        }
    }
    
    func doRound(_ objects: UILabel...) {
        for label in objects {
            label.layer.cornerRadius = label.frame.size.width / 2;
            label.clipsToBounds = true;
        }
        
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
    
    func returnSimpleKeyVal() -> [String:String] {
        return ["login":"login","pwd":"pwd","user_type":"isStylist","avatar":"avatar","diploma":"diploma"];
    }
    
    func returnSkin() -> [String] {
        return ["Белая/молочная (плохо загораю/сгораю)",
                "Оливковая",
                "Смуглая (хорошо загораю)"]
    }
    
    func returnHair() -> [String] {
        return ["Светлый (блондин(-ка))",
                "Брюнет(-ка)",
                "Рыжий",
                "Шатен",
                "Русый (темный/светлый)"]
    }
    
    func returnBrown() -> [String] {
        return ["Белая/молочная (плохо загораю/сгораю)",
                "Оливковая",
                "Смуглая (хорошо загораю)"]
    }
    
    func returnVenous() -> [String] {
        return ["Голубоватый оттенок","Зеленоватый оттенок"]
    }
    
    func returnTriangleHelpText() -> String {
        return "Мы выбрали самые часто встречающиеся типы фигур. Обратите внимание как распредёлен Ваш вес: какая часть 'перевешивает'. Основной вес приходится на низ (бёдра) - Ваш тип фигуры 'треугольник'"
    }
    
    func returnRevertTriangleText() -> String {
        return "Мы выбрали самые часто встречающиеся типы фигур. Обратите внимание как распредёлен Ваш вес: какая часть 'перевешивает'. Основной вес приходится на верх (грудная клетка массивнее бёдер) - Ваш тип фигуры 'перевернутый треугольник'"
    }
    
    func returnHourglassText() -> String {
        return "Мы выбрали самые часто встречающиеся типы фигур. Обратите внимание как распредёлен Ваш вес: какая часть 'перевешивает'. Верх и низ фигуры уравновешены (грудная клетка и плечи примерно того же объёма, как бёдра) - Ваш тип фигуры 'песочные часы'"
    }
}
