//
//  FKAvatar.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/10/21.
//  Modified by Daniel on 2015/11/17.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit
import SceneKit
import AFNetworking

/**
 An avatar object.
 */
class FKAvatar: NSObject {
    
    /**
     The `avatarID` for avatar's ID.
     */
    let avatarID: String!
    
    /**
     The `gender` for gender of avatar. Default is `Male`.
     */
    let gender: FKGender!
    
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
    
    /**
     The `bodyImages` for body of avatar.
     
     TODO: Complete parameter `skinColor`, the parameter `headImages` and `bodyImages` are set to private.
     */
    var bodyImages: [FKSkinColor: UIImage] = [:]
    
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
    
    /**
     The `clothes` for clothes of avatar. If `nil`, the avatar hasn't clothes.
     */
    var clothes: FKAvatarClothes?
    
    /**
     The `motion` for motion of avatar. If `nil`, the avatar hasn't motion.
     */
    var motion: FKAvatarMotion?
    
    var glasses: FKAvatarGlasses?
    
    var skinColor = FKSkinColor.Default
    
    /**
     Creates a avatar from an avatar's id. The gender of avatar default is `Male`.
     
     TODO: This initialization will be changed to find avatar at CoreData.
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
        let requestOperation = AFHTTPRequestOperation(request: request)
        requestOperation.responseSerializer = AFImageResponseSerializer()
        requestOperation.setCompletionBlockWithSuccess({ (operation, responseObject) -> Void in
            if let responseObject = responseObject as? UIImage {
                self.headImages[skinColor] = responseObject
            }
            }, failure: { (operation, error) -> Void in
                
        })
        requestOperation.start()
    }
    
    func getAvatarBodyImage(skinColor: FKSkinColor, url: NSURL) {
        let request = NSURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30)
        let requestOperation = AFHTTPRequestOperation(request: request)
        requestOperation.responseSerializer = AFImageResponseSerializer()
        requestOperation.setCompletionBlockWithSuccess({ (operation, responseObject) -> Void in
            if let responseObject = responseObject as? UIImage {
                self.bodyImages[skinColor] = responseObject
            }
            }, failure: { (operation, error) -> Void in
                
        })
        requestOperation.start()
    }
    
    func getAvatarRefInfo(url: NSURL) {
        let request = NSURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30)
        let requestOperation = AFHTTPRequestOperation(request: request)
        requestOperation.responseSerializer = AFHTTPResponseSerializer()
        requestOperation.setCompletionBlockWithSuccess({ (operation, responseObject) -> Void in
            if let responseObject = responseObject as? NSData {
                self.refInfo = String(NSString(data: responseObject, encoding: NSUTF8StringEncoding))
            }
            }, failure: { (operation, error) -> Void in
                
        })
        requestOperation.start()
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
