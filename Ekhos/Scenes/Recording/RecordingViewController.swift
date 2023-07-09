//
//  RecordingViewController.swift
//  Ekhos
//
//  Created by Filipe Cruz on 08/07/23.
//

import Foundation
//import AVFoundation
import UIKit
import DSWaveformImage
import AudioKit

final class RecordingViewController: UIViewController {//, AVAudioRecorderDelegate {
    let customView: RecordingView
    //TODO: viewModel
    

    var engine: AudioEngine!
    var mic: AudioEngine.InputNode!
    var bandpassFilter: AudioKit.BandPassFilter!
    //    var recordingSession: AVAudioSession!
//    var audioRecorder: AVAudioRecorder!
    var timer: Timer?

    init(customView: RecordingView) {
        self.customView = customView
        engine = AudioEngine()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        view = customView
    }
    var micBooster: Fader?
    var pitchShifter: PitchShifter?
    var tracker: PitchTap!

    
    func createRecorder() {
        do {
            mic = engine.input!
            
            let micMixer = Mixer(mic)
            
            let filter = HighPassFilter(mic, cutoffFrequency: 220, resonance: 40)

            tracker = PitchTap(filter, handler: {_ , _ in })
            micBooster = Fader(micMixer)

            pitchShifter = PitchShifter(micBooster!, shift: -3)

            micBooster!.gain = 5

            engine.output = pitchShifter
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
//        timer?.invalidate()
//        timer = nil
//        audioRecorder.stop()
//        audioRecorder = nil

    }
}

extension RecordingViewController: RecordingViewDelegate {
    @objc private func updateAmplitude() {
//        audioRecorder.updateMeters()
//
//        print("current power: \(audioRecorder.averagePower(forChannel: 0)) dB")
//
//        let currentAmplitude = 1 - pow(10, (audioRecorder.averagePower(forChannel: 0) / 20))
//        customView.setupWaveView(samples: [currentAmplitude, currentAmplitude, currentAmplitude])
    }
    
    func startRecording() {
        createRecorder()
//        recordingSession = AVAudioSession.sharedInstance()

        do {
            try engine.start()

//            try recordingSession.setCategory(.playAndRecord, mode: .default)
//            try recordingSession.setActive(true)
//            recordingSession.requestRecordPermission() { [unowned self] allowed in
//                DispatchQueue.main.async {
//                    if allowed {
////                        audioRecorder.record()
////                        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAmplitude), userInfo: nil, repeats: true)
//                    } else {
//                        // failed to record!
//                    }
//                }
//            }
        } catch {
            // failed to record!
        }
    }
    
    func stopRecording() {
        engine.stop()
        finishRecording(success: true)
        customView.stopWaveView()
    }
}
