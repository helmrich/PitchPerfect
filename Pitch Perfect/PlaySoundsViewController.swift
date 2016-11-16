//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Tobias Helmrich on 10.03.16.
//  Copyright © 2016 Tobias Helmrich. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Play"
        
        audioPlayer = try! AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
        
        
        setSessionPlayerOn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudioWithSpeed(of speed: Float) {
        resetAudio()
        audioPlayer.rate = speed
        audioPlayer.play()
    }
    
    
    @IBAction func stopAudio(_ sender: AnyObject) {
        resetAudio()
    }
    
    func resetAudio() {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
    }
    
    @IBAction func slowSound(_ sender: AnyObject) {
        playAudioWithSpeed(of: 0.5)
    }
    
    @IBAction func fastSound(_ sender: AnyObject) {
        playAudioWithSpeed(of: 2.0)
    }
    
    @IBAction func chipmunkSound(_ sender: AnyObject) {
        playAudioWithPitch(of: 1000)
    }
    
    @IBAction func darthVaderSound(_ sender: AnyObject) {
        playAudioWithPitch(of: -1000)
    }
    
    @IBAction func echoSound(_ sender: AnyObject) {
        playAudioWithDelay(of: 1.0)
    }
    
    
    
    func playAudioWithPitch(of pitch: Float) {
        resetAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    // The following code adds another effect (echo). It's very similar to changing the pitch with the
    // difference that I used the AVAudioUnitDelay class instead of AVAudioUnitTimePitch and setting the
    // time delay instead of the pitch
    func playAudioWithDelay(of delayInSeconds: TimeInterval) {
        resetAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let setDelayEffect = AVAudioUnitDelay()
        setDelayEffect.delayTime = delayInSeconds
        audioEngine.attach(setDelayEffect)
        
        audioEngine.connect(audioPlayerNode, to: setDelayEffect, format: nil)
        audioEngine.connect(setDelayEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    
    // The following is not a part of the original Pitch Perfect App but was added because I think
    // it is a better experience to use the speakers on the bottom of the iPhone instead of the
    // earphone on the top
    // The following code comes from this (http://stackoverflow.com/questions/29526435/force-audio-file-playback-through-iphone-loud-speaker-using-swift ) 
    // Stackoverflow thread as it provided exactly the code that was needed to achieve the above mentioned
    func setSessionPlayerOn()
    {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch _ {
        }
    }
    func setSessionPlayerOff()
    {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch _ {
        }
    }

}
