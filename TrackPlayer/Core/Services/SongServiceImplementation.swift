//
//  SongServiceImplementation.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation
import Combine

class SongServiceImplementation{

    let baseUrl: URL
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
}

extension String: Error {}

extension SongServiceImplementation: SongService {
    
    func getSongs(byQuery query: String, limit: Int) -> AnyPublisher<[TrackSong], Error> {
        
        //API documentation
        //https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/Searching.html
        
        var urlComps = URLComponents(url: self.baseUrl, resolvingAgainstBaseURL: false)
        urlComps?.path = "/search"
        urlComps?.queryItems = [
            .init(name: "term", value: query),
            .init(name: "limit", value: "\(limit)")
        ]
        
        guard let url = urlComps?.url else {
            
            return Fail(error: AppError.apiError(reason: "Failed url request!"))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw AppError.apiError(reason: "Bad server response")
                }
                return element.data
            }
            .map{ data in
                if let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    debugPrint(jsonData)
                }
                return data
            }
            .decode(type: TrackSerachResponse.self, decoder: JSONDecoder())
            .map{ response in
                response.results
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    
    func loadRecentSongs() -> AnyPublisher<[TrackSong], Error> {
        
        //Mock method
        return Just([])
            .setFailureType(to: Error.self)
            .delay(for: 1, scheduler: DispatchQueue.global(qos: .userInitiated))
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

