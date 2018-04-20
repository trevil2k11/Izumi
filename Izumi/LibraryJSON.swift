//
//  LibraryJSON.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 17.05.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import Foundation
import UIKit

class LibraryJSON {
    
    let helperLib = Helper();
    
    func returnAuth(_ login: String, pwd: String) -> String {
        return "{\"controller\":\"auth\",\"action\":\"trytoauth\",\"login\":\"" + login + "\",\"pwd\":\"" + pwd + "\"}";
    }
    
    func returnUpdateField(_ id: String, table: String, field: String, value: String, type: String, val_length: Int) -> String {
        var resultString = "{\"controller\":\"users\",\"action\":\"updatefield\",\"user_id\":\"" + id + "\",\"table\":\"" + table
        resultString += "\",\"field\":\"" + field  + "\",\"value\":\"" + value + "\",\"type\":\"" + type
        resultString += "\",\"length\":\"" + String(val_length) + "\"}";
        
        return resultString;
    }
    
    func returnLib(_ lower_id: String, upper_id: String) -> String {
        return "{\"controller\":\"loaders\",\"action\":\"getlib\",\"low_id\":\"" + lower_id + "\",\"upper_id\":\"" + upper_id + "\"}";
    }
    
    func returnLibNew(_ dt: String) -> String {
        return "{\"controller\":\"loaders\",\"action\":\"getlibnew\",\"dt\":\"" + dt + "\"}";
    }
    
    func returnChangePlace(_ pic_id: String, place_id: String) -> String {
        return "{\"controller\":\"loaders\",\"action\":\"setpicplace\",\"pic_id\":\"" + pic_id + "\",\"place_id\":\"" + place_id + "\"}";
    }
    
    func returnComments(_ id: String) -> String {
        return "{\"controller\":\"comments\",\"action\":\"getlibcomments\",\"pic_id\":\"" + id + "\"}";
    }
    
    func returnAddComment(_ login: String, pic_id: String, comment: String) -> String {
        return "{\"controller\":\"comments\",\"action\":\"addcomment\",\"login\":\"" + login + "\",\"pic_id\":\"" + pic_id + "\",\"comm\":\"" + comment + "\"}";
    }
    
    func returnBestPict(_ user_id: String) -> String {
        return "{\"controller\":\"loaders\",\"action\":\"getbestpict\",\"user_id\":\"" + user_id + "\"}";
    }
    
    func returnUserProfile(_ user_id: String) -> String {
        return "{\"controller\":\"users\",\"action\":\"read\",\"user_id\":\"" + user_id + "\"}";
    }
    
    func returnUserDetails(_ user_id: String) -> String {
        return "{\"controller\":\"users\",\"action\":\"getuserdetails\",\"user_id\":\"" + user_id + "\"}";
    }
    
    func returnUserWardrobe(_ user_id: String) -> String {
        return "{\"controller\":\"users\",\"action\":\"getuserwardrobe\",\"user_id\":\"" + user_id + "\"}";
    }
    
    func returnUserWardrobeHeaders(_ user_id: String) -> String {
        return "{\"controller\":\"users\",\"action\":\"getwardrobeheaders\",\"user_id\":\"" + user_id + "\"}";
    }
    
    func returnStylistWardrobe(_ user_id: String) -> String {
        return "{\"controller\":\"users\",\"action\":\"getstylistwardrobe\",\"user_id\":\"" + user_id + "\"}";
    }
    
    func returnStylistWardrobeHeaders(_ user_id: String) -> String {
        return "{\"controller\":\"users\",\"action\":\"getstylistwardrobeheaders\",\"user_id\":\"" + user_id + "\"}";
    }
    
    func returnPlaces() -> String {
        return "{\"controller\":\"loaders\",\"action\":\"getplaces\"}";
    }
    
    func returnUpdateStylistActivity(_ user_id: String) -> String {
        return "{\"controlles\":\"users\",\"action\":\"updateactivity\",\"user_id\":\"" + user_id + "\"}";
    }
    
    func returnUploadPicture(_ params: [String:String]) -> String {
        var resStr: String = "{\"controller\":\"loaders\",\"action\":\"upload\",\"id\":\""+params["user_id"]! + "\",\"place\":\"4\",\"name\":\"\",\"description\":\"\",\"file_name\":\"\",\"pic_data\":\"";
        resStr = (helperLib.returnCyrillicAndJsoned(resStr as NSString) as String) + params["pic_data"]! + (helperLib.returnCyrillicAndJsoned("\"}") as String)
        
        return resStr
    }
    
    func returnFullURL(_ part: String = "") -> String {
        return "http://izumi-style.ru/api/" + part
    }
    
    func returnCreateUser(_ params: [String:String]) -> String{
        let deviceId:String = UIDevice.current.identifierForVendor!.uuidString
        
        var resultStr: String = "{\"controller\":\"users\",\"action\":\"create\",\"login\":\"" + params["login"]! + "\",\"pwd\":\"" + params["pwd"]! + "\",\"device_id\":\"" + deviceId + "\",\"user_type\":\"" + params["user_type"]! + "\",\"avatar\":\""
        resultStr += helperLib.percentEscapeString(params["avatar"]!) + (helperLib.specUnicodeCyrillic("\",\"diploma\":\"") as String)
        resultStr += helperLib.percentEscapeString(params["diploma"]!) + (helperLib.specUnicodeCyrillic("\"}") as String);
        return helperLib.specUnicodeCyrillic(resultStr as NSString) as String;
    }
    
    func returnCreateUserOld(_ params: [String:String]) -> String{
        let deviceId:String = UIDevice.current.identifierForVendor!.uuidString
        
        var resultStr: String = "{\"controller\":\"users\",\"action\":\"create\",\"login\":\"" + params["login"]! + "\",\"pwd\":\"" + params["pwd"]! + "\",\"email\":\"" + params["email"]! + "\",\"date_birth\":\"" + params["dt_birth"]! + "\",\"sex\":\"" + params["sex"]! + "\",\"device_id\":\"" + deviceId + "\",\"type_up\":\"" + params["typeUp"]! + "\",\"type_mid_up\":\"" + params["typeMidUp"]! + "\",\"type_mid_down\":\"" + params["typeMidDown"]! + "\",\"type_bottom\":\"" + params["typeBottom"]! + "\",\"comment\":\"" + params["comment"]! + "\",\"hair\":\"" + params["hair"]! + "\",\"skin\":\"" + params["skin"]! + "\",\"brown\":\"" + params["brown"]! + "\",\"eyes\":\"" + params["eyes"]! + "\",\"eyes_add\":\"" + params["eyesAdd"]! + "\",\"venous_color\":\"" + params["venousColor"]! + "\",\"place\":\"" + params["place"]! + "\",\"full_picture\":\"";
        resultStr = helperLib.specUnicodeCyrillic(resultStr as NSString) as String;
        resultStr += helperLib.percentEscapeString(params["fullPicture"]!) + (helperLib.specUnicodeCyrillic("\",\"avatar\":\"") as String)
        resultStr += helperLib.percentEscapeString(params["avatarPic"]!) + (helperLib.specUnicodeCyrillic("\"}") as String);
        
        return resultStr;
    }
    
    func returnCreateStylist(_ params: [String:String]) -> String{
        let deviceId:String = UIDevice.current.identifierForVendor!.uuidString
        
        var resultStr: String = "{\"controller\":\"users\",\"action\":\"createstylist\",\"login\":\"" + params["login"]! + "\",\"pwd\":\"" + params["pwd"]! + "\",\"email\":\"" + params["email"]! + "\",\"date_birth\":\"" + params["dateBirth"]! + "\",\"sex\":\"" + params["sex"]! + "\",\"device_id\":\"" + deviceId + "\",\"school\":\"" + params["education"]! + "\",\"expirience\":\"" + params["expirience"]! + "\",\"projects\":\"" + params["projects"]! +   "\",\"place\":\"\",\"diploma\":\"";
        resultStr = helperLib.specUnicodeCyrillic(resultStr as NSString) as String;
        resultStr += helperLib.percentEscapeString(params["diploma"]!) + (helperLib.specUnicodeCyrillic("\",\"avatar\":\"") as String)
        resultStr += helperLib.percentEscapeString(params["avatar"]!) + (helperLib.specUnicodeCyrillic("\"}") as String);
        
        return resultStr;
    }
}
