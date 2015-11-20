//
//  SPECameraViewController.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/10/16.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit
import AVFoundation
import ReactiveCocoa
import Swift_RAC_Macros
import MBProgressHUD
import FaceKit
import SceneKit

class SPECameraViewController: SPEViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var videoView: UIView?

    @IBOutlet var changeCameraButton: UIButton?
    
    var delegate: SPECameraViewControllerDelegate?
    
    var frontCameraSession = AVCaptureSession()
    var backCameraSession = AVCaptureSession()
    var frontCameraStillImageOutput = AVCaptureStillImageOutput()
    var backCameraStillImageOutput = AVCaptureStillImageOutput()
    var frontCameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var backCameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    dynamic var faceImage: UIImage?
    
    override func loadView() {
        super.loadView()
        
        self.frontCameraSession.sessionPreset = AVCaptureSessionPreset1280x720
        self.backCameraSession.sessionPreset = AVCaptureSessionPreset1280x720
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RACObserve(self, "faceImage").ignoreNil().subscribeNext { (faceImage) -> Void in
            if let faceImage = faceImage as? UIImage {
                FKAvatarManager.currentManager.createAvatar(gender: .Male, faceImage: faceImage, success: { (avatarNode) -> Void in
                    MBProgressHUD.hideAllHUDsForView(self.view.window, animated: true)
                    
                    self.delegate?.cameraViewController?(self, didCreateAvatarNode: avatarNode)
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    }, failure: { (error) -> Void in
                        
                })
            }
        }
        
        self.setupCamera()
        
        self.frontCameraAction()
        changeCameraButton?.addTarget(self, action: "backCameraAction", forControlEvents: .TouchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let videoView = self.videoView {
            self.frontCameraPreviewLayer?.frame = videoView.bounds
            self.backCameraPreviewLayer?.frame = videoView.bounds
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let alertController = UIAlertController(title: NSLocalizedString("No camera available in this device", comment: "Showing error while there is no camera in this device"), message: NSLocalizedString("Insta3D requires camera to work", comment: "Showing error while there is o camera in this device"), preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCamera() {
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if let device = device as? AVCaptureDevice {
                if device.hasMediaType(AVMediaTypeVideo) {
                    do {
                        switch device.position {
                        case .Front:
                            let frontCameraInput = try AVCaptureDeviceInput(device: device)
                            self.frontCameraSession.addInput(frontCameraInput)
                            
                            if self.frontCameraSession.canAddOutput(frontCameraStillImageOutput) {
                                self.frontCameraSession.addOutput(frontCameraStillImageOutput)
                            }
                            
                            self.frontCameraPreviewLayer = AVCaptureVideoPreviewLayer(session: self.frontCameraSession)
                            self.frontCameraPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                            self.videoView?.layer.addSublayer(self.frontCameraPreviewLayer!)
                            break
                        case .Back:
                            let backCameraInput = try AVCaptureDeviceInput(device: device)
                            self.backCameraSession.addInput(backCameraInput)
                            
                            if self.backCameraSession.canAddOutput(backCameraStillImageOutput) {
                                self.backCameraSession.addOutput(backCameraStillImageOutput)
                            }
                            
                            self.backCameraPreviewLayer = AVCaptureVideoPreviewLayer(session: self.backCameraSession)
                            self.backCameraPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                            self.videoView?.layer.addSublayer(self.backCameraPreviewLayer!)
                            break
                        default:
                            break
                        }
                    }
                    catch {}
                }
            }
        }
    }
    
    func showLoadingView() {
        self.frontCameraSession.stopRunning()
        self.backCameraSession.stopRunning()
        self.frontCameraPreviewLayer?.hidden = true
        self.backCameraPreviewLayer?.hidden = true
        self.videoView?.layer.contents = self.faceImage?.CGImage
        
        let hud = MBProgressHUD(view: self.view.window)
        hud.labelText = "Loading..."
        
        self.view.window?.addSubview(hud)
        hud.show(true)
    }
    
    // MARK: - action
    
    @IBAction func cancelAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func albumAction() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .PhotoLibrary
        
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func shutterAction() {
        
        var stillImageOutput: AVCaptureStillImageOutput
        
        if self.backCameraPreviewLayer?.hidden == true {
            stillImageOutput = frontCameraStillImageOutput
        }
        else {
            stillImageOutput = backCameraStillImageOutput
        }
        
        let connection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)
        
        // update the video orientation to the device one
        if connection.supportsVideoOrientation {
            connection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.currentDevice().orientation.rawValue)!
        }
        
        stillImageOutput.captureStillImageAsynchronouslyFromConnection(connection) {
            (imageDataSampleBuffer, error) -> Void in
            
            if error == nil {
                
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                
                if let image = UIImage(data: imageData)?.fixOrientation() {
                    self.faceImage = image
                    
                    self.showLoadingView()
                }
            }
            else {
                NSLog("error while capturing still image: \(error)")
            }
        }
    }
    
    func frontCameraAction() {
        self.backCameraSession.stopRunning()
        self.frontCameraSession.startRunning()
        
        self.backCameraPreviewLayer?.hidden = true
        self.frontCameraPreviewLayer?.hidden = false
        
        changeCameraButton?.removeTarget(self, action: "frontCameraAction", forControlEvents: .TouchUpInside)
        changeCameraButton?.addTarget(self, action: "backCameraAction", forControlEvents: .TouchUpInside)
        
        changeCameraButton?.setTitle("Back", forState: .Normal)
    }
    
    func backCameraAction() {
        self.frontCameraSession.stopRunning()
        self.backCameraSession.startRunning()
        
        self.frontCameraPreviewLayer?.hidden = true
        self.backCameraPreviewLayer?.hidden = false
        
        changeCameraButton?.removeTarget(self, action: "backCameraAction", forControlEvents: .TouchUpInside)
        changeCameraButton?.addTarget(self, action: "frontCameraAction", forControlEvents: .TouchUpInside)
        
        changeCameraButton?.setTitle("Front", forState: .Normal)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.faceImage = image.fixOrientation()
        }
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.showLoadingView()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

@objc
protocol SPECameraViewControllerDelegate: NSObjectProtocol {
    optional func cameraViewController(viewController: SPECameraViewController, didCreateAvatarNode avatarNode: FKAvatarSceneNode)
}
