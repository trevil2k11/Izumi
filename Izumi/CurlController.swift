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
    
    func sendData(_ input:String, completionHandler: @escaping (NSString?)->()) -> Void{
        let url:URL = URL(string: "http://trevilre.bget.ru/api/")!
        let request = NSMutableURLRequest(url: url);
        request.httpMethod = "POST";
//        request.cachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad;
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData;
        request.httpBody = ("data=" + input).data(using: String.Encoding.utf8, allowLossyConversion: true);
        
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
}
