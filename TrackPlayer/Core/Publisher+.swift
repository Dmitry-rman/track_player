//
//  Publisher+.swift
//  TrackPlayer
//
//  Created by Dmitry on 16.03.2023.
//

import Combine

public extension Publisher {
    
    func sinkIgnoringAll() -> AnyCancellable {
        
        return sink(receiveCompletion: { result in
  
        }, receiveValue: { value in
            
        })
    }
    
    func sinkStore(in set: inout Set<AnyCancellable>){
        sinkIgnoringAll()
            .store(in: &set)
    }
}
