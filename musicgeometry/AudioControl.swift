//
//  AudioControl.swift
//  melo
//
//  Created by John Fowler on 10/28/24.
// Copyright (C) John J. Fowler 2024, 2025
//

import AVFoundation

enum AudioControlError: Error {
  case NoBackingtrackFile
}

class AudioControl {
  private let engine = AVAudioEngine()
  private var audioPlayer: AVAudioPlayer?   // for playing backing track
  private let sampler = AVAudioUnitSampler()
  private let reverb = AVAudioUnitReverb()
  private let delay = AVAudioUnitDelay()
  
  init() {
    setupAudioControl()
  }
  
  private func setupAudioControl() {
    // comment out if not wanting realistic piano sound
    loadSoundFont()
    
    engine.attach(sampler)
    engine.connect(sampler, to: engine.mainMixerNode, format: nil)
    
    let audioSession = AVAudioSession.sharedInstance()
    
    do {
      try audioSession.setCategory(.playback, mode: .default)
      try audioSession.setActive(true)
    } catch {
      print("Error setting up audio session: \(error.localizedDescription)")
    }
  }

  // only works on MacOS and simulator
  private func loadMacOSSoundFont() {
    do {
      try sampler.loadSoundBankInstrument(at: URL(fileURLWithPath: "/System/Library/Components/CoreAudio.component/Contents/Resources/gs_instruments.dls"),
                                          program: 0,
                                          bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
                                          bankLSB: UInt8(kAUSampler_DefaultBankLSB))
    } catch {
      print("Error loading sound font: \(error.localizedDescription)")
    }
  }
  
  private func loadSoundFont() {
    if let soundFontURL = Bundle.main.url(forResource: "PianoMuted", withExtension: "sf2") {
      do {
        try sampler.loadSoundBankInstrument(at: soundFontURL,
                                            program: 0,
                                            bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
                                            bankLSB: UInt8(kAUSampler_DefaultBankLSB))
      } catch {
        print("Error loading sound font: \(error.localizedDescription)")
      }
    } else {
      print("error locating sound font in bundle")
    }
  }
  
  func cueBackingTrack(at: TimeInterval) {
    audioPlayer?.currentTime = at
  }
  
  func getBackingTrackTimestamp() -> TimeInterval {
    return audioPlayer!.currentTime
  }
  
  func startBackingTrackPlayback() {
    // Start background audio
    audioPlayer?.play()
  }
  
  func stopBackingTrackPlayback() {
    audioPlayer?.pause()
  }
  
  func setBackingTrackVolume(volume: Float) {
    audioPlayer?.volume = volume
  }

  // not recommended, just leaving here as example of audio pipeline 
  private func setupWithReverbAndDelay() {
    engine.attach(sampler)
    engine.attach(reverb)
    engine.attach(delay)

    engine.connect(sampler, to: delay, format: nil)
    engine.connect(delay, to: reverb, format: nil)
    engine.connect(reverb, to: engine.mainMixerNode, format: nil)

    // Reverb
    reverb.loadFactoryPreset(.mediumHall)
    reverb.wetDryMix = 30.0

    // Delay
    delay.wetDryMix = 15.0
    delay.delayTime = 0.50
    delay.feedback = 75.0
    delay.lowPassCutoff = 16000.0
  }

  func start() {
    if engine.isRunning {
      print("Audio engine already running")
      return
    }
    
    do {
      try engine.start()
      print("Audio engine started")
    } catch {
      print("Error starting audio engine: \(error.localizedDescription)")
      return
    }
  }
  
  func playNote(keyNumber: Int8, velocity: UInt8) {
    sampler.startNote(UInt8(keyNumber), withVelocity: velocity, onChannel: 0)
  }
  
  func stopNote(keyNumber: Int8) {
    sampler.stopNote(UInt8(keyNumber), onChannel: 0)
  }
  
  
}
