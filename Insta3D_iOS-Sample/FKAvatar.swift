//
//  FKAvatar.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel iMac on 2015/10/21.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit
import SceneKit

/** An avatar object.
 
 TODO: This class will be changed private and created `class FKAvatarNode: SCNNode`, `class FKAvatarView: SCNView`
 */
public class FKAvatar: NSObject {
    /** The `avatarID` for avatar's ID.
     */
    public let avatarID: String!
    /** The `gender` for gender of avatar. Default is `Male`.
     */
    public let gender: FKGender!
    /** The `headImages` for head of avatar.
     
     TODO: Complete parameter `skinColor`, the parameter `headImages` and `bodyImages` are set to private.
     */
    public var headImages: [FKHeadSkinColor: UIImage] = [:] {
        didSet {
            self.defaultDownloaded = self.headImages[.Default] != nil && self.refInfo != nil
        }
    }
    /** The `bodyImages` for body of avatar.
     
     TODO: Complete parameter `skinColor`, the parameter `headImages` and `bodyImages` are set to private.
     */
    public var bodyImages: [FKBodySkinColor: UIImage] = [:]
    /** The `refInfo` for information of avatar. This string include all expression for avatar.
     */
    public var refInfo: String? {
        willSet {
            if let refInfo = newValue {
                self.setupGeometrySources(refInfo)
            }
        }
        didSet {
            self.defaultDownloaded = self.headImages[.Default] != nil && self.refInfo != nil
        }
    }
    /** The `defaultDownloaded` for `refInfo` and default of `headImages` downloaded complete. The value can use ReactiveCocoa.
     */
    public dynamic var defaultDownloaded = false
    var oriHeadCenter: SCNVector3?
    var refHeadCenter: SCNVector3?
    var scaleFactor: SCNVector3?
    
    /** The `geometrySourcesSemanticNormal` for avatar of head's 15 geometry source are an array of normal vectors.
     */
    public var geometrySourcesSemanticNormal: [SCNGeometrySource] = []
    /** The `geometrySourcesSemanticVertex` for avatar of head's 15 geometry source are an array of vertex positions.
     */
    public var geometrySourcesSemanticVertex: [SCNGeometrySource] = []
    
    /** The `hair` for hair of avatar. If `nil`, the avatar hasn't hair.
     */
    public var hair: FKAvatarHair?
    /** The `clothes` for clothes of avatar. If `nil`, the avatar hasn't clothes.
     */
    public var clothes: FKAvatarClothes?
    /** The `motion` for motion of avatar. If `nil`, the avatar hasn't motion.
     */
    public var motion: FKAvatarMotion?
    
    /** Creates a avatar from an avatar's id. The gender of avatar default is `Male`.
     
     TODO: This initialization will be changed to find avatar at CoreData.
     */
    public init(avatarID: String!) {
        self.avatarID = avatarID
        self.gender = .Male
    }
    
    /** Creates a avatar from an avatar's id and gender of avatar.
     
     TODO: This initialization will be deprecated and replaced by `class func createAvatar(faceImage: UIImage)`.
     */
    public init(avatarID: String!, gender: FKGender!) {
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
}

/** Options for gender of avatar.
 
 The key name follows API v3.
 */
public enum FKGender: String {
    /** The gender of avatar is male.
     */
    case Male = "AM"
    /** The gender of avatar is female.
     */
    case Female = "AFM"
}

/** Options for skin color of avatar to head.
 
 The key name follows API v3.
 */
public enum FKHeadSkinColor: String {
    /** The skin color is default color.
     */
    case Default = "Hd"
    /** The skin color is black.
     */
    case Black = "Hd_black"
    /** The skin color is brown.
     */
    case Brown = "Hd_brown"
    /** The skin color is red.
     */
    case Red = "Hd_red"
    /** The skin color is yellow.
     */
    case Yellow = "Hd_yellow"
}

/** Options for skin color fo avatar to body.
 
 The key name follows API v3.
 */
public enum FKBodySkinColor: String {
    /** The skin color is default color.
     */
    case Default = "Bd"
    /** The skin color is black.
     */
    case Black = "Bd_black"
    /** The skin color is brown.
     */
    case Brown = "Bd_brown"
    /** The skin color is red.
     */
    case Red = "Bd_red"
    /** The skin color is yellow.
     */
    case Yellow = "Bd_yellow"
}
