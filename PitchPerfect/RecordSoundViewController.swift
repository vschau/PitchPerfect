//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Vanessa on 5/7/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enablePlayButton(true)
    }

    @IBAction func recordAudio(_ sender: Any) {
        enablePlayButton(false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        enablePlayButton(true)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was nor succesful")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundViewController = segue.destination as! PlaySoundsViewController
            let recordedSoundURL = sender as! URL
            playSoundViewController.recordedAudioURL = recordedSoundURL
        }
    }
    
    func enablePlayButton(_ enabled: Bool) {
        stopRecordingButton.isEnabled = !enabled
        recordButton.isEnabled = enabled
        if enabled {
            recordingLabel.text = "Tap to Record"
        } else {
            recordingLabel.text = "Recording in progress"
        }
        
    }
}

