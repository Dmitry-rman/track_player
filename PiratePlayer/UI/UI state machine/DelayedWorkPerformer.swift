//
//  DelayedWorkPerformer.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

/// Компонент для выполнения блока кода с задержкой и возможностью отмены
final class DelayedWorkPerformer {
    
    /// Блок код, запланированный для исполнения
    private(set) var delayedWork: DispatchWorkItem?
    
    /// Выполнить блок кода с задержкой
    /// - Parameters:
    ///   - queue: очередь, на которой будет выполняться код (по умолчанию .main)
    ///   - delay: задержка
    ///   - work: блок кода
    func perform(on queue: DispatchQueue = .main, with delay: TimeInterval, work: @escaping () -> Void) {
        
        let delayed = DispatchWorkItem { [weak self] in
            self?.delayedWork = nil
            work()
        }
        
        delayedWork = delayed
        
        queue.asyncAfter(deadline: .now() + delay, execute: delayed)
    }
}
