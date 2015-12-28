//
//  FKMutableURLRequest.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/12/21.
//  Modified by Daniel on 2015/12/23.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit

private let FK_Platform = "iOS"

class FKMutableURLRequest: NSMutableURLRequest {
    
    init(path: String, cachePolicy: NSURLRequestCachePolicy = .UseProtocolCachePolicy, timeoutInterval: NSTimeInterval = 60) {
        guard var URL = NSURL(string: "http://api.spe3d.co/v3/avatar") else {
            super.init(URL: NSURL(), cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
            return
        }
        
        URL = URL.URLByAppendingPathComponent(path)
        
        super.init(URL: URL, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        
        self.setValue(FK_Platform, forHTTPHeaderField: "Insta3D-Platform")
        self.setValue(FKAvatarManager.APIKey, forHTTPHeaderField: "Insta3D-API-Key")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHTTPParameters(parameters: [String: String]?, dataFormat: FKHTTPDataFormat = .FormURL) {
        guard let parameters = parameters else {
            return
        }
        
        let body = NSMutableData()
        
        switch dataFormat {
        case .FormURL:
            let parameterArray = parameters.map({ (key: String, value: String) -> String in
                guard let keyString = key.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
                    return ""
                }
                guard let valueString = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
                    return ""
                }
                return "\(keyString)=\(valueString)"
            }).filter({ (string: String) -> Bool in
                return !string.isEmpty
            })
            
            guard let data = parameterArray.joinWithSeparator("&").dataUsingEncoding(NSUTF8StringEncoding) else {
                self.HTTPBody = nil
                return
            }
            body.appendData(data)
            self.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            break
        case .JSON:
            guard let jsonData = try? NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted) else {
                self.HTTPBody = nil
                return
            }
            
            body.appendData(jsonData)
            self.setValue("application/json", forHTTPHeaderField: "Content-Type")
            break
        }
        
        self.HTTPBody = body
    }
    
    func setHTTPParameters(parameters: [String: String]?, image: UIImage) {
        guard let parameters = parameters else {
            return
        }
        
        let body = NSMutableData()
        
        let boundary = String(format: "Boundary+%08X%08X", arc4random(), arc4random())
        
        guard let boundaryData = "\r\n--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding) else {
            return
        }
        
        for (key, value) in parameters {
            body.appendData(boundaryData)
            guard let dispositionData = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding) else {
                continue
            }
            body.appendData(dispositionData)
        }
        
        // add file
        body.appendData(boundaryData)
        
        guard let dispositionData = "Content-Disposition: form-data; name=\"photo\"; filename=\"tempPhoto.jpg\"\r\n".dataUsingEncoding(NSUTF8StringEncoding) else {
            return
        }
        body.appendData(dispositionData)
        
        guard let typeData = "Content-Type: image/jpeg\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding) else {
            return
        }
        body.appendData(typeData)
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else {
            return
        }
        body.appendData(imageData)
        
        
        guard let endBoundaryData = "\r\n--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding) else {
            return
        }
        body.appendData(endBoundaryData)
        
        self.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        self.HTTPBody = body
    }
}

enum FKHTTPDataFormat: Int {
    case FormURL
    
    case JSON
}
