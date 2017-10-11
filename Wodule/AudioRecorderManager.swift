//
//  AudioRecorderManager.swift
//  Wodule
//
//  Created by QTS Coder on 10/10/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecorderManager: NSObject {
    
    static let shared = AudioRecorderManager()
    
    var recordingSession: AVAudioSession!
    var recorder:AVAudioRecorder?
    
    func setup(){
        
         recordingSession = AVAudioSession.sharedInstance()
        
        do {
            
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.defaultToSpeaker])
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission() {[weak self] (allowed: Bool) -> Void  in
                
                if allowed {
                    print("Recording Allowed")
                    
                } else {
                    print("Recording Allowed Faild")
                    
                }
                
            }

            
        } catch {
            print("Faild to setCategory",error.localizedDescription)
        }
        
        guard self.recordingSession != nil else {
            print("Error session is nil")
            return
        }
        
        
    }
    
    
    func getUserDocumentsPath()->URL{
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        return documentsURL
    }
    
    var meterTimer:Timer?
    
    func recored(fileName:String,result:(_ isRecording:Bool, _ audioURL: NSURL?)->Void) {
        
        let path = getUserDocumentsPath().appendingPathComponent(fileName+".m4a")
        
        let audioURL = NSURL(fileURLWithPath: path.path)

       
        let recoredSt:[String:Any] = [
            AVFormatIDKey:NSNumber(value: kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey : 12000.0,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey : 44100.0
        ]
        
        do {
            recorder = try AVAudioRecorder(url: audioURL as URL, settings: recoredSt)
            recorder?.delegate = self
            
            recorder?.isMeteringEnabled = true
//            recorder?.prepareToRecord()
            
            recorder?.record()
            
            
            self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                   target:self,
                                                   selector:#selector(AudioRecorderManager.updateAudioMeter(timer:)),
                                                   userInfo:nil,
                                                   repeats:true)
            result(true, audioURL)
            print("Recording")
            
        } catch {
            result(false, nil)
        }
    }
    
    
    var recorderTime: String?
    var recorderApc0: Float?
    var recorderPeak0:Float?
    
    func updateAudioMeter(timer:Timer){
        
        if let recorder = recorder {
            
            let dFormat = "%02d"
            let min:Int = Int(recorder.currentTime / 60)
            let sec:Int = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60.0))
            
            recorderTime  = "\(String(format: dFormat, min)):\(String(format: dFormat, sec))"
            
            recorder.updateMeters()
            recorderApc0 = recorder.averagePower(forChannel: 0)
            recorderPeak0 = recorder.peakPower(forChannel: 0)
            
            
        }
    }
   
    
    func finishRecording()
    {
        
        self.recorder?.stop()
        self.meterTimer?.invalidate()
        
        

    }
   
    
    

}

extension AudioRecorderManager:AVAudioRecorderDelegate{
    
    // Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        print("Audio Recorder did finish",flag)
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,error: Error?) {
        print("\(String(describing: error?.localizedDescription))")
    }
    
}






