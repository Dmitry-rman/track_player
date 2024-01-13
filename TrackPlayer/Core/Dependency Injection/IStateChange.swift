//
//  IStateChange.swift
//  TrackPlayer
//
//  Created by Dmitry on 13.01.2024.
//

protocol IStateChange: AnyObject {
    func favoritsChanged(_ value: Int)
}
