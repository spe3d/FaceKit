//
//  SPECameraViewController.swift
//  FaceKit
//
//  Created by Daniel on 2015/10/16.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit
import AVFoundation
import MBProgressHUD
import FaceKit
import SceneKit

class SPECameraViewController: SPEViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var videoView: UIView!

    @IBOutlet var changeCameraButton: UIButton!

    var delegate: SPECameraViewControllerDelegate?

    var frontCameraSession = AVCaptureSession()
    var backCameraSession = AVCaptureSession()
    var frontCameraStillImageOutput = AVCaptureStillImageOutput()
    var backCameraStillImageOutput = AVCaptureStillImageOutput()
    var frontCameraPreviewLayer = AVCaptureVideoPreviewLayer()
    var backCameraPreviewLayer = AVCaptureVideoPreviewLayer()

    var showCameraDeniedMessage = false

    var faceImage: UIImage?

    var gender = FACGender.male

    override func loadView() {
        super.loadView()

        self.frontCameraSession.sessionPreset = AVCaptureSessionPresetHigh
        self.backCameraSession.sessionPreset = AVCaptureSessionPresetHigh
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized:
            self.setupCamera()
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) -> Void in
                if granted {
                    self.setupCamera()
                }
                else {
                    self.showCameraDeniedMessage = true
                }
            })
            break
        case .restricted:
            break
        case .denied:
            self.showCameraDeniedMessage = true
            break
        }

        self.frontCameraAction()
        changeCameraButton.addTarget(self, action: #selector(SPECameraViewController.backCameraAction), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.frontCameraPreviewLayer.frame = self.videoView.bounds
        self.backCameraPreviewLayer.frame = self.videoView.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.showCameraDeniedMessage {
            self.cameraDenied()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupCamera() {
        let devices = AVCaptureDevice.devices()
        for device in devices! {
            if let device = device as? AVCaptureDevice {
                if device.hasMediaType(AVMediaTypeVideo) {
                    do {
                        switch device.position {
                        case .front:
                            let frontCameraInput = try AVCaptureDeviceInput(device: device)
                            self.frontCameraSession.addInput(frontCameraInput)

                            if self.frontCameraSession.canAddOutput(frontCameraStillImageOutput) {
                                self.frontCameraSession.addOutput(frontCameraStillImageOutput)
                            }

                            self.frontCameraPreviewLayer.session = self.frontCameraSession
                            self.frontCameraPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            self.videoView.layer.addSublayer(self.frontCameraPreviewLayer)
                            break
                        case .back:
                            let backCameraInput = try AVCaptureDeviceInput(device: device)
                            self.backCameraSession.addInput(backCameraInput)

                            if self.backCameraSession.canAddOutput(backCameraStillImageOutput) {
                                self.backCameraSession.addOutput(backCameraStillImageOutput)
                            }

                            self.backCameraPreviewLayer.session = self.backCameraSession
                            self.backCameraPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            self.videoView.layer.addSublayer(self.backCameraPreviewLayer)
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

    func cameraDenied() {
        let alertView = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: nil, preferredStyle: .alert)

        var alertText = ""
        // `UIApplicationOpenSettingsURLString` availables in iOS 8.0 and later.
        // This APP supports iOS 8.0 or later.
        // So, we do not need to consider other cases in general.
        if let openSettingsURL = URL(string: UIApplicationOpenSettingsURLString) {
            alertText = NSLocalizedString("It looks like your privacy settings are preventing us from accessing your camera to do barcode scanning. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Touch Privacy.\n\n3. Turn the Camera on.\n\n4. Open this app and try again.", comment: "")

            alertView.addAction(UIAlertAction(title: NSLocalizedString("Go", comment: ""), style: UIAlertActionStyle.default, handler: { (action :UIAlertAction) -> Void in
                UIApplication.shared.openURL(openSettingsURL)
            }))
        }

        alertView.message = alertText

        alertView.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))

        self.present(alertView, animated: true, completion: nil)
    }

    func showLoadingView() {
        self.frontCameraSession.stopRunning()
        self.backCameraSession.stopRunning()
        self.frontCameraPreviewLayer.isHidden = true
        self.backCameraPreviewLayer.isHidden = true
        self.videoView.layer.contents = self.faceImage?.cgImage

        let hud = MBProgressHUD(view: self.view.window)
        hud?.labelText = "Loading..."

        self.view.window?.addSubview(hud!)
        hud?.show(true)
    }

    func createAvatar() {
        if let faceImage = self.faceImage {
            FACAvatarManager.current().createAvatar(with: gender, face: faceImage, successBlock: { (avatarController) -> Void in
                MBProgressHUD.hideAllHUDs(for: self.view.window, animated: true)

                self.delegate?.cameraViewController?(self, didCreateAvatarController: avatarController)

                self.dismiss(animated: true, completion: nil)
                }, failureBlock: { (error) -> Void in

            })
        }
    }

    // MARK: - action

    @IBAction func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func albumAction() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary

        self.present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func shutterAction() {

        var stillImageOutput: AVCaptureStillImageOutput

        if self.backCameraPreviewLayer.isHidden == true {
            stillImageOutput = frontCameraStillImageOutput
        }
        else {
            stillImageOutput = backCameraStillImageOutput
        }

        let connection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo)

        // update the video orientation to the device one
        if (connection?.isVideoOrientationSupported)! {
            connection?.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue)!
        }

        stillImageOutput.captureStillImageAsynchronously(from: connection) {
            (imageDataSampleBuffer, error) -> Void in

            if error == nil {

                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)

                if let image = UIImage(data: imageData!)?.fixOrientation() {
                    self.faceImage = image
                    self.createAvatar()

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

        self.backCameraPreviewLayer.isHidden = true
        self.frontCameraPreviewLayer.isHidden = false

        changeCameraButton.removeTarget(self, action: #selector(SPECameraViewController.frontCameraAction), for: .touchUpInside)
        changeCameraButton.addTarget(self, action: #selector(SPECameraViewController.backCameraAction), for: .touchUpInside)

        changeCameraButton.setTitle("Back", for: UIControlState())
    }

    func backCameraAction() {
        self.frontCameraSession.stopRunning()
        self.backCameraSession.startRunning()

        self.frontCameraPreviewLayer.isHidden = true
        self.backCameraPreviewLayer.isHidden = false

        changeCameraButton.removeTarget(self, action: #selector(SPECameraViewController.backCameraAction), for: .touchUpInside)
        changeCameraButton.addTarget(self, action: #selector(SPECameraViewController.frontCameraAction), for: .touchUpInside)

        changeCameraButton.setTitle("Front", for: UIControlState())
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.faceImage = image.fixOrientation()
            self.createAvatar()
        }

        self.dismiss(animated: true) { () -> Void in
            self.showLoadingView()
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

@objc
protocol SPECameraViewControllerDelegate: NSObjectProtocol {
    @objc optional func cameraViewController(_ viewController: SPECameraViewController, didCreateAvatarController avatarController: FACAvatarController)
}
