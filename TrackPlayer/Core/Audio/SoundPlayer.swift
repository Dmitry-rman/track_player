//
//  SoudPlayer.swift
//  TrackPlayer
//
//  Created by Dmitry on 05.03.2023.
//

import AVFoundation
import AVFAudio

protocol SoundPlayer{
    
    func play(url: URL?, fromBegin: Bool)
    func pause()
    func resume()
    func stop()
    
    var trackUrl: URL? {get}
    
    var isPlayingCahnged: ((Bool)->())? {get set}
    var timeChanged: ((Int)->())? {get set}
    var onReadyToPlayChanged: ((_ duration: Int?)->())? {get set}
    var isLoaded: Bool {get}
    var duration: Int? {get}
    
    func setVolume(_ value: Float)
}

class AVSoundPlayer: SoundPlayer{
    
    private var audioPlayer: AVPlayer?
    private var observer: NSKeyValueObservation?
    
    var isPlayingCahnged: ((Bool)->())?
    var timeChanged: ((Int)->())?
    var onReadyToPlayChanged: ((_ duration: Int?)->())?
    
    @objc private func playerDidFinishPlaying(note: NSNotification) {
        trackUrl = nil
        isPlayingCahnged?(false)
    }
    
    init() {
        
        NotificationCenter.default.addObserver(self,
                                          selector:  #selector(playerDidFinishPlaying(note:)),
                                          name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                          object: nil)
    }
    
    deinit{
        self.observer?.invalidate()
        NotificationCenter.default.removeObserver(self)
        debugPrint("deinit \(Self.self)")
    }
    
    //MARK: - TrackPlayer
    
    private(set) var trackUrl: URL?
    
    func setVolume(_ value: Float) {
        audioPlayer?.volume = value * 0.01
    }
    
    var duration: Int?{
        if let item =  self.audioPlayer?.currentItem{
            if item.duration != .indefinite {
                return Int(item.duration.seconds)
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    var isLoaded: Bool{
        return self.audioPlayer?.status == .readyToPlay
    }
    
    func play(url: URL?, fromBegin: Bool = true){
        
        if trackUrl == url, fromBegin == false{
            resume()
        }
        else if let url = url {
                let item = AVPlayerItem(url: url)
                
                self.audioPlayer = AVPlayer(playerItem: item)
                self.audioPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1),
                                                          queue: DispatchQueue.main,
                                                          using: {[weak self] (time) in
                    guard let player = self?.audioPlayer else {return}
                    
                    if player.currentItem?.status == .readyToPlay {
                        let currentTime = CMTimeGetSeconds(player.currentTime())
                        let secs = Int(currentTime)
                        self?.timeChanged?(secs)
                    }
                }
                )
            
            
               self.observer?.invalidate()
               // Register as an observer of the player item's status property
             
                self.observer = item.observe(\.status, options:  [.new, .old],
                                                    changeHandler: { [weak self] (playerItem, change) in
                    
                    guard let self = self else {return}
                    
                    if playerItem.status == .readyToPlay {
                        //Do your work here
                        self.onReadyToPlayChanged?(self.duration)
                    }
                })
            
                self.trackUrl = url
                resume()
        }
    }
    
    func pause() {
        self.audioPlayer?.pause()
        isPlayingCahnged?(false)
    }
    
    func resume(){
        if trackUrl != nil {
            self.audioPlayer?.play()
            isPlayingCahnged?(true)
        }
    }
    
    func stop() {
        self.pause()
        self.trackUrl = nil
    }
    
}
