//
//  CurlController.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 09.03.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import Foundation
import UIKit

class CurlController {
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    fileprivate var helperLib = Helper();
    fileprivate var jsonLib = LibraryJSON();
    
    func sendData(_ input:String, completionHandler: @escaping (NSString?)->()) -> Void{
        let url:URL = URL(string: "http://izumi-style.ru/api/")!
        let request = NSMutableURLRequest(url: url);
        
        request.httpMethod = "POST";
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData;
        request.httpBody = (input).data(using: .utf8, allowLossyConversion: true);
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        
        dataTask = defaultSession.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completionHandler(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
                    return
                }
            }
        }) 
        dataTask!.resume();
    }
    
    func imageUploadRequest(imageData: Data, param: [String:String]?) {
        let url:URL = URL(string: "http://izumi-style.ru/api/")!
        let request = NSMutableURLRequest(url: url);
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData as NSData, boundary: boundary) as Data
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest,
             completionHandler: {
                (data, response, error) -> Void in
                if let data = data {
                    let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    let json = try!JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                } else if let error = error {
                    print(error.localizedDescription)
                }
        })
        task.resume()
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user_picture_" + parameters!["id"]! + String(Date().timeIntervalSince1970) + ".jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

