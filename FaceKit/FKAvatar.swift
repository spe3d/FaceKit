//
//  FKAvatar.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/10/21.
//  Modified by Daniel on 2016/01/04.
//  Copyright © 2015-2016年 Speed 3D Inc. All rights reserved.
//

import UIKit
import SceneKit

/**
 An avatar object.
 */
class FKAvatar: NSObject, NSSecureCoding {
    
    /**
     The `avatarID` for avatar's ID.
     */
    let avatarID: String!
    let kAvatarID = "avatarID"
    
    /**
     The `gender` for gender of avatar. Default is `Male`.
     */
    let gender: FKGender
    let kGender = "gender"
    
    /**
     The `headImages` for head of avatar.
     
     TODO: Complete parameter `skinColor`, the parameter `headImages` and `bodyImages` are set to private.
     */
    var headImages: [FKSkinColor: UIImage] = [:] {
        didSet {
            if self.headImages[.Default] != nil && self.refInfo != nil {
                self.downloadCompleted?()
                self.downloadCompleted = nil
            }
        }
    }
    let kHeadImages = "headImages"
    
    /**
     The `bodyImages` for body of avatar.
     
     TODO: Complete parameter `skinColor`, the parameter `headImages` and `bodyImages` are set to private.
     */
    var bodyImages: [FKSkinColor: UIImage] = [:]
    let kBodyImages = "bodyImages"
    
    /**
     The `refInfo` for information of avatar. This string include all expression for avatar.
     */
    var refInfo: String? {
        willSet {
            if let refInfo = newValue {
                self.setupGeometrySources(refInfo)
            }
        }
        didSet {
            if self.headImages[.Default] != nil && self.refInfo != nil {
                self.downloadCompleted?()
                self.downloadCompleted = nil
            }
        }
    }
    let kRefInfo = "refInfo"
    
    var downloadCompleted: (()->Void)?
    
    
    var oriHeadCenter: SCNVector3?
    var refHeadCenter: SCNVector3?
    var scaleFactor: SCNVector3?
    
    /**
     The `geometrySourcesSemanticNormal` for avatar of head's 15 geometry source are an array of normal vectors.
     */
    var geometrySourcesSemanticNormal: [SCNGeometrySource] = []
    
    /**
     The `geometrySourcesSemanticVertex` for avatar of head's 15 geometry source are an array of vertex positions.
     */
    var geometrySourcesSemanticVertex: [SCNGeometrySource] = []
    
    /**
     The `hair` for hair of avatar. If `nil`, the avatar hasn't hair.
     */
    var hair: FKAvatarHair?
    let kHair = "hair"
    
    /**
     The `clothes` for clothes of avatar. If `nil`, the avatar hasn't clothes.
     */
    var clothes: FKAvatarClothes?
    let kClothes = "clothes"
    
    /**
     The `motion` for motion of avatar. If `nil`, the avatar hasn't motion.
     */
    var motion: FKAvatarMotion?
    let kMotion = "motion"
    
    var glasses: FKAvatarGlasses?
    let kGlasses = "glasses"
    
    var skinColor = FKSkinColor.Default
    let kSkinColor = "skinColor"
    
    init(gender: FKGender) {
        self.avatarID = ""
        self.gender = gender
    }
    
    /**
     Creates a avatar from an avatar's id. The gender of avatar default is `Male`.
     */
    init(avatarID: String!) {
        self.avatarID = avatarID
        self.gender = .Male
    }
    
    /**
     Creates a avatar from an avatar's id and gender of avatar.
     */
    init(avatarID: String!, gender: FKGender!) {
        self.avatarID = avatarID
        self.gender = gender
    }
    
    /**
     Returns an object initialized from data in a given unarchiver.
     */
    required init(coder aDecoder: NSCoder) {
        self.avatarID   = aDecoder.decodeObjectOfClass(NSString.self, forKey: self.kAvatarID) as! String
        self.gender     = FKGender(rawValue: aDecoder.decodeObjectOfClass(NSString.self, forKey: self.kGender) as! String)!
        
        let headImages = aDecoder.decodeObjectOfClass(NSDictionary.self, forKey: self.kHeadImages) as! [String: NSData]
        for (key, value) in headImages {
            self.headImages[FKSkinColor(rawValue: key)!] = NSKeyedUnarchiver.unarchiveObjectWithData(value) as? UIImage
        }
        
        let bodyImages = aDecoder.decodeObjectOfClass(NSDictionary.self, forKey: self.kBodyImages) as! [String: NSData]
        for (key, value) in bodyImages {
            self.bodyImages[FKSkinColor(rawValue: key)!] = NSKeyedUnarchiver.unarchiveObjectWithData(value) as? UIImage
        }
        
        self.refInfo    = aDecoder.decodeObjectOfClass(NSString.self, forKey: self.kRefInfo) as? String
        self.hair       = aDecoder.decodeObjectOfClass(FKAvatarHair.self, forKey: self.kHair)
        self.clothes    = aDecoder.decodeObjectOfClass(FKAvatarClothes.self, forKey: self.kClothes)
        self.motion     = aDecoder.decodeObjectOfClass(FKAvatarMotion.self, forKey: self.kMotion)
        self.glasses    = aDecoder.decodeObjectOfClass(FKAvatarGlasses.self, forKey: self.kGlasses)
        
        self.skinColor  = FKSkinColor(rawValue: aDecoder.decodeObjectOfClass(NSString.self, forKey: self.kSkinColor) as! String)!
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.avatarID, forKey: self.kAvatarID)
        aCoder.encodeObject(self.gender.rawValue, forKey: self.kGender)
        var headImages: [String: NSData] = [:]
        for (key, value) in self.headImages {
            headImages[key.rawValue] = NSKeyedArchiver.archivedDataWithRootObject(value)
        }
        aCoder.encodeObject(headImages, forKey: self.kHeadImages)
        
        var bodyImages: [String: NSData] = [:]
        for (key, value) in self.bodyImages {
            bodyImages[key.rawValue] = NSKeyedArchiver.archivedDataWithRootObject(value)
        }
        aCoder.encodeObject(bodyImages, forKey: self.kBodyImages)
        
        aCoder.encodeObject(self.refInfo, forKey: self.kRefInfo)
        aCoder.encodeObject(self.hair, forKey: self.kHair)
        aCoder.encodeObject(self.clothes, forKey: self.kClothes)
        aCoder.encodeObject(self.motion, forKey: self.kMotion)
        aCoder.encodeObject(self.glasses, forKey: self.kGlasses)
        aCoder.encodeObject(self.skinColor.rawValue, forKey: self.kSkinColor)
    }
    
    static func supportsSecureCoding() -> Bool {
        return true
    }
    
    func setupGeometrySources(refInfo: String) {
        var values = refInfo.componentsSeparatedByString("\n")
        var vectorString: [String]
        
        //--- OriHeadCenter
        vectorString = values.first!.componentsSeparatedByString(" ")
        self.oriHeadCenter = SCNVector3Make(Float(vectorString[1])!, Float(vectorString[2])!, Float(vectorString[3])!)
        values.removeFirst()
        
        //--- RefHeadCenter
        vectorString = values.first!.componentsSeparatedByString(" ")
        self.refHeadCenter = SCNVector3Make(Float(vectorString[1])!, Float(vectorString[2])!, Float(vectorString[3])!)
        values.removeFirst()
        
        //--- ScaleFactor
        vectorString = values.first!.componentsSeparatedByString(" ")
        self.scaleFactor = SCNVector3Make(Float(vectorString[1])!, Float(vectorString[2])!, Float(vectorString[3])!)
        values.removeFirst()
        
        //--- NumFacialVertices
        values.removeFirst()
        let vertexNum = Int(values.first!.componentsSeparatedByString(" ")[1])!
        values.removeFirst()
        
        //--- NumFacialExpressions
        let expressionNum = Int(values.first!.componentsSeparatedByString(" ")[1])!
        values.removeFirst()
        
        //--- FaceialVertices & FacialExpressions Data
        for _ in 0..<expressionNum {
            values.removeFirst()
            var normalVectors: [SCNVector3] = []
            var vertexVectors: [SCNVector3] = []
            for _ in 0..<vertexNum {
                vectorString = values.first!.componentsSeparatedByString(" ")
                vertexVectors.append(SCNVector3Make(Float(vectorString[0])!, Float(vectorString[1])!, Float(vectorString[2])!))
                normalVectors.append(SCNVector3Make(Float(vectorString[3])!, Float(vectorString[4])!, Float(vectorString[5])!))
                values.removeFirst()
            }
            self.geometrySourcesSemanticNormal.append(SCNGeometrySource(normals: normalVectors, count: vertexNum))
            self.geometrySourcesSemanticVertex.append(SCNGeometrySource(vertices: vertexVectors, count: vertexNum))
        }
    }
    
    func setupAvatar(data: [String:String]) {
        for (skinColorName, skinColorURL) in data {
            if let url = NSURL(string: skinColorURL) {
                
                if skinColorName == "RefInfo" {
                    self.getAvatarRefInfo(url)
                }
                else {
                    var skinColor = ""
                    
                    if skinColorName.characters.count > 2 {
                        skinColor = skinColorName.substringFromIndex(skinColorName.startIndex.advancedBy(3))
                    }
                    
                    if skinColorName.hasPrefix("Hd") {
                        if let headSkinColor = FKSkinColor(rawValue: skinColor) {
                            self.getAvatarHeadImage(headSkinColor, url: url)
                        }
                    }
                    else if skinColorName.hasPrefix("Bd") {
                        if let bodySkinColor = FKSkinColor(rawValue: skinColor) {
                            self.getAvatarBodyImage(bodySkinColor, url: url)
                        }
                    }
                }
            }
        }
    }
    
    func getAvatarHeadImage(skinColor: FKSkinColor, url: NSURL) {
        let request = NSURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if let _ = error {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    return
                }
                
                self.headImages[skinColor] = image
            }
        }
        
        task.resume()
    }
    
    func getAvatarBodyImage(skinColor: FKSkinColor, url: NSURL) {
        let request = NSURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if let _ = error {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    return
                }
                
                self.bodyImages[skinColor] = image
            }
        }
        
        task.resume()
    }
    
    func getAvatarRefInfo(url: NSURL) {
        let request = NSURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if let _ = error {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                if let refInfo = String(data: data, encoding: NSUTF8StringEncoding) {
                    self.refInfo = refInfo
                }
            }
        }
        
        task.resume()
    }
}

/**
 Options for gender of avatar.
 
 The key name follows API v3.
 */
public enum FKGender: String {
    /**
     The gender of avatar is male.
     */
    case Male = "AM"
    /**
     The gender of avatar is female.
     */
    case Female = "AFM"
}

/**
 Options for skin color of avatar to head.
 
 The key name follows API v3.
 */
public enum FKSkinColor: String {
    /**
     The skin color is default color.
     */
    case Default = ""
    /**
     The skin color is black.
     */
    case Black = "black"
    /**
     The skin color is brown.
     */
    case Brown = "brown"
    /**
     The skin color is red.
     */
    case Red = "red"
    /**
     The skin color is yellow.
     */
    case Yellow = "yellow"
}
