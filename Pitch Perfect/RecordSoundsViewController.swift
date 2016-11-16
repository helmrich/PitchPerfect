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

    override func viewWillAppear(_ animated: Bool) {
        pauseButton.setImage(UIImage(named: "PauseButton"), for: UIControlState())
        toggleButtons(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        toggleButtons(false)
        recordingInProgress.text = "Recording ..."
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathString = "\(dirPath)/\(recordingName)"
        let filePath = URL(fileURLWithPath: pathString)
        
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func toggleButtons(_ showOrHide: Bool) {
        pauseButton.isHidden = showOrHide
        stopButton.isHidden = showOrHide
        recordButton.isEnabled = showOrHide
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            // Save the recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            
            // Perform the segue
            self.performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        } else {
            print("Couldn't save audio!")
            recordButton.isEnabled = true
            recordingInProgress.isHidden = true
            stopButton.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "stopRecording") {
            let PlaySoundsVC: PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            
            PlaySoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(_ sender: UIButton) {
        recordingInProgress.text = "Tap to Record"
        recordButton.isEnabled = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func pauseRecording(_ sender: AnyObject) {
        if(audioRecorder.isRecording) {
            setPauseButton(withText: "Paused ... Tap to Record", buttonName: "PlayButton")
            audioRecorder.pause()
        } else {
            setPauseButton(withText: "Recording ...", buttonName: "PauseButton")
            audioRecorder.record()
        }
    }
    
    func setPauseButton(withText recordingInProgressText: String, buttonName: String) {
        recordingInProgress.text = recordingInProgressText
        pauseButton.setImage(UIImage(named: buttonName), for: UIControlState())
    }
    
    
}

