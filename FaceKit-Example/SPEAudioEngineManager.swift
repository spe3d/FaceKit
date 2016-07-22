import Foundation
import AVFoundation
import FaceKit

class SPEAudioEngineManager: NSObject {
    
    enum State: UInt {
        case Default
        case isRecording
        case isPlaying
    }
    
    dynamic private(set) var statusKVOKey : UInt = State.Default.rawValue
    private(set) var status: State = .Default {
        didSet {
            statusKVOKey = status.rawValue
        }
    }
    
    var avatarController: FKAvatarController?
    
    let sampleRate = 22050
    
    private var audioEngine = AVAudioEngine()
    private var outputFile = AVAudioFile()
    
    // MARK: - File URL
    // URL for saved RecData
    func recFileURL() -> NSURL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
        let pathArray = [dirPath, "rec.aac"]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        return filePath!
    }
    
    // remove file
    func removeRecFile() {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        let path = url.URLByAppendingPathComponent("rec.aac").path!
        if manager.fileExistsAtPath(path) {
            try! manager.removeItemAtPath(path)
        }
    }
    
    // MARK:
    func setup() {
        // AudioSession
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
        } catch let error as NSError  {
            print("Error : \(error)")
        }
    }
    
    private var converterNode : AVAudioMixerNode?
    func record() {
        status = .isRecording
        
        self.setup()
        self.avatarController?.startRecord(self.sampleRate)
        
        //Output Format
        let intputFormat =
            audioEngine.inputNode!.outputFormatForBus(0)
        let outputFormat =
            AVAudioFormat.init(commonFormat: intputFormat.commonFormat,
                               sampleRate: Double(sampleRate),
                               channels: AVAudioChannelCount(1),
                               interleaved: false)
        
        var settings = outputFormat.settings
        settings[AVFormatIDKey] = NSNumber(unsignedInt: kAudioFormatMPEG4AAC)
        
        // set outputFile
        removeRecFile()
        outputFile = try! AVAudioFile(forWriting: recFileURL(), settings: settings)
        
        //Convertor
        if converterNode == nil {
            converterNode = AVAudioMixerNode()
            if let node = converterNode {
                audioEngine.attachNode(node)
                audioEngine.connect(audioEngine.inputNode!, to: node, format: audioEngine.inputNode!.outputFormatForBus(0))
                audioEngine.connect(node, to: audioEngine.outputNode, format: outputFormat)
            }
        }
        
        converterNode?.installTapOnBus(0, bufferSize: 1024, format: converterNode?.outputFormatForBus(0)) { (buffer, when) in
            
            try! self.outputFile.writeFromBuffer(buffer)
            
            //avatarController write
            let firstChannel = buffer.floatChannelData[0]
            let array = Array(UnsafeBufferPointer(start: firstChannel, count: Int(buffer.frameLength)))
            let doublesArray = array.map({ (value) -> Double in
                return Double(value)
            })
            
            //TODO: If buffer.floatChannelData is nil, or value out of range [-1, 1]
            let error = self.avatarController?.append(doublesArray)
            if (error != nil) {
                print(error)
            }
        }
        
        // AVAudioEngine start
        if !audioEngine.running {
            do {
                try audioEngine.start()
            } catch let error as NSError {
                print("Couldn't start engine, \(error.localizedDescription)")
            }
        }
    }
    
    func stopRecord() {
        status = .Default
        
        // audioEngine stop
        converterNode?.removeTapOnBus(0)
        audioEngine.stop()
        
        print("Music Length:\(Float(self.outputFile.length) / Float(sampleRate)) s")
        
        let dict = try! NSFileManager.defaultManager().attributesOfItemAtPath(self.outputFile.url.path!)
        print("File Size:\((dict[NSFileSize] as! Int) / 1024)KB")
        
        //TODO: If buffer.floatChannelData is nil, or value out of range [-1, 1]
        let error = self.avatarController?.stopRecord({
            self.avatarController?.saveVoice(self.recFileURL().path!);
        })
        if (error != nil) {
            print(error)
        }
    }
    
    func playRecData() {
        status = .isPlaying
        
        self.avatarController?.startPlayVoiceAnimation({ (success) in
            self.status = .Default
        })
    }
    
    func stopRecData() {
        status = .Default
        
        self.avatarController?.stopPlayVoiceAnimation()
    }
}