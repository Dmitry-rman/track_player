//
//  SoudPlayer.swift
//  TrackPlayer
//
//  Created by Dmitry on 05.03.2023.
//

import SwiftUI
import AVFoundation
import AVFAudio
import Combine

protocol SoundPlayer{
    
    var soundUrl: URL? {get}
    func playSound(url: URL?, fromBegin: Bool)
    func pause()
    func resume()
    func stop()
    
    var isPlaying: Bool {get}
    var isLoaded: Bool {get}
    
    var volume: Float {get set}
}

class AVSoundPlayer: SoundPlayer, ObservableObject {
    
    private var audioPlayer: AVPlayer?
    private(set) var soundUrl: URL?
    private var cancellableSet = Set<AnyCancellable>()
    
    @Published public var volume: Float = UserPreferences.volume
    
    init() {
        
        $volume
            .sink { [weak self] value in
                UserPreferences.volume = value
                self?.audioPlayer?.volume = value * 0.01
            }
            .store(in: &cancellableSet)
            
    }
    
    @objc private func playerDidFinishPlaying(note: NSNotification) {
        soundUrl = nil
        self.isPlaying = false
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
        debugPrint("deinit \(Self.self)")
    }
    
    //MARK: - SoundPlayer
    
    @Published public private(set) var isPlaying: Bool = false
    
    var isLoaded: Bool{
        return self.audioPlayer?.status == .readyToPlay
    }
    
    func playSound(url: URL?, fromBegin: Bool = true){
        
        if soundUrl != nil, fromBegin == false{
            resume()
        }
         else if soundUrl == nil{

            NotificationCenter.default.removeObserver(self)
            
            if let url = url {
                let item = AVPlayerItem(url: url)
                NotificationCenter.default.addObserver(self,
                                                       selector:  #selector(playerDidFinishPlaying(note:)),
                                                       name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                       object: item)
                self.audioPlayer = AVPlayer(playerItem: item)
                self.audioPlayer?.volume = self.volume * 0.01
                self.soundUrl = url
                resume()
            }
         }else{
             resume()
         }
    }
    
    func pause() {
        self.audioPlayer?.pause()
        self.isPlaying = false
    }
    
    func resume(){
        if soundUrl != nil {
            self.audioPlayer?.play()
            self.isPlaying = true
        }
    }
    
    func stop() {
        self.pause()
        self.soundUrl = nil
    }

}
