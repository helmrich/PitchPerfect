//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Tobias Helmrich on 10.03.16.
//  Copyright © 2016 Tobias Helmrich. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        pauseButton.setImage(UIImage(named: "PauseButton"), forState: UIControlState.Normal)
        toggleButtons(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        toggleButtons(false)
        recordingInProgress.text = "Recording ..."
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func toggleButtons(showOrHide: Bool) {
        pauseButton.hidden = showOrHide
        stopButton.hidden = showOrHide
        recordButton.enabled = showOrHide
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            // Save the recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            
            // Perform the segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Couldn't save audio!")
            recordButton.enabled = true
            recordingInProgress.hidden = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let PlaySoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            
            PlaySoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.text = "Tap to Record"
        recordButton.enabled = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func pauseRecording(sender: AnyObject) {
        if(audioRecorder.recording) {
            setPauseButton(withText: "Paused ... Tap to Record", buttonName: "PlayButton")
            audioRecorder.pause()
        } else {
            setPauseButton(withText: "Recording ...", buttonName: "PauseButton")
            audioRecorder.record()
        }
    }
    
    func setPauseButton(withText recordingInProgressText: String, buttonName: String) {
        recordingInProgress.text = recordingInProgressText
        pauseButton.setImage(UIImage(named: buttonName), forState: UIControlState.Normal)
    }
    
    
}

