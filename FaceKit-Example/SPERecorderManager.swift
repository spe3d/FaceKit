//
//  SPERecorderManager.swift
//  FaceKit
//
//  Created by w91379137 on 2016/7/12.
//  Copyright © 2016年 Speed 3D Inc. All rights reserved.
//

import UIKit
import FaceKit

class SPERecorderManager: NSObject {

    weak var recButton: UIButton? {
        didSet {
            reloadButtonsTitle()
        }
    }
    weak var playButton: UIButton? {
        didSet {
            reloadButtonsTitle()
        }
    }
    
    private var context = 0
    
    var avatarController: FKAvatarController? {
        didSet {
            audioEngineMnager.avatarController = self.avatarController
        }
    }
    
    var audioEngineMnager = SPEAudioEngineManager()
    
    //MARK: - Init
    override init() {
        super.init()
        audioEngineMnager.addObserver(self,
                            forKeyPath: "statusKVOKey",
                            options: [.Initial, .New],
                            context: &context)
    }
    
    deinit {
        audioEngineMnager.removeObserver(self,
                                         forKeyPath: "statusKVOKey",
                                         context: &context)
    }
    
    //MARK: - Observer
    override func observeValueForKeyPath(keyPath: String?,
                                         ofObject object: AnyObject?,
                                                  change: [String : AnyObject]?,
                                                  context: UnsafeMutablePointer<Void>) {
        if context == context {
            reloadButtonsTitle()
        }
        else {
            super.observeValueForKeyPath(keyPath,
                                         ofObject: object,
                                         change: change,
                                         context: context)
        }
    }
    
    func reloadButtonsTitle() {
        switch audioEngineMnager.status {
        case .Default:
            playButton?.setTitle("Play Start", forState: .Normal)
            recButton?.setTitle("Rec Start", forState: .Normal)
            
        case .isRecording:
            playButton?.setTitle("Play x", forState: .Normal)
            recButton?.setTitle("Rec Stop", forState: .Normal)
            
        case .isPlaying:
            playButton?.setTitle("Play Stop", forState: .Normal)
            recButton?.setTitle("Rec x", forState: .Normal)
            break
        }
    }
    
    //MARK:
    func recButtonPushed() {
        switch audioEngineMnager.status {
        case .Default:
            audioEngineMnager.record()
        case .isRecording:
            audioEngineMnager.stopRecord()
        case .isPlaying: break
        }
    }
    
    func playButtonPushed() {
        switch audioEngineMnager.status {
        case .Default:
            audioEngineMnager.playRecData()
        case .isPlaying:
            audioEngineMnager.stopRecData()
        case .isRecording: break
        }
    }
}
