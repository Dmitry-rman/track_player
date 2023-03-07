//
//  AudioEngine.swift
//  PiratePlayer
//
//  Created by Dmitry on 07.03.2023.
//

import AVFoundation

protocol AudioEngineProtocol{
    
    func createPlayer() -> AVSoundPlayer
    
    func initAudioSession() throws
}

struct AudioEngine: AudioEngineProtocol{
    
    func createPlayer() -> AVSoundPlayer{
         AVSoundPlayer()
    }
    
    func initAudioSession() throws{
        
        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        debugPrint("AVAudioSession Category Playback OK")
        
        try AVAudioSession.sharedInstance().setActive(true)
        debugPrint("AVAudioSession is Active")
    }
}
