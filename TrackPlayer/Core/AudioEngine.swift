//
//  AudioEngine.swift
//  TrackPlayer
//
//  Created by Dmitry on 07.03.2023.
//

import AVFoundation

protocol AudioEngineProtocol{
    
    func createPlayer() -> AVSoundPlayer
    
    func initAudioSession() throws
}

class AudioEngine: AudioEngineProtocol{
    
    private var _isAudioSessionInitialized: Bool = false
    
    func createPlayer() -> AVSoundPlayer{
         AVSoundPlayer()
    }
    
    func initAudioSession() throws{
        
        if  _isAudioSessionInitialized == true{
            return
        }
        
        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        debugPrint("AVAudioSession Category Playback OK")
        
        try AVAudioSession.sharedInstance().setActive(true)
        debugPrint("AVAudioSession is Active")
        
        _isAudioSessionInitialized = true
    }
}
