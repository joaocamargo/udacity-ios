//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by joao camargo on 10/04/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("viewWillAppear called")
        stopRecordingButton.isEnabled = false
    }
    
    
    @IBAction func recordAudio(_ sender: Any) {
        //print("record button was pressed")
        self.configureUi(enable: false)

        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]

        let filePath = URL(string: pathArray.joined(separator: "/"))
        //print(filePath ?? "")
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        self.configureUi(enable: true)
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag
        {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            
        } else{
            print("Recording not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"
        {
            let playSoundsVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func configureUi(enable: Bool)
    {
        recordButton.isEnabled = enable
        stopRecordingButton.isEnabled = !enable
        
        if enable {
            audioRecorder.stop()
            recordingLabel.text = "Tap to Record..."
        }
        else{
            recordingLabel.text = "Recording..."
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        //print("audio Recorder Encode Error did occure ")
        //print(Error.self)
    }
    
}

