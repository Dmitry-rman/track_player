//
//  ViewStateChangeCondition.swift
//  Portable
//

import Foundation

/// Условие для перехода между состояниями UI стейт машины
protocol ViewStateChangeCondition {
    
    /// Обработать переход между состояниями
    /// - Parameters:
    ///   - state: новое состояние
    ///   - stateMachine: стейт машина
    func setState<T>(_ state: ViewState<T>, with stateMachine: ViewStateMachine<T>)
}

/// Обработчик логики переходов между состояниями UI стейт машины
class ViewStateChangeTransitionHandler {
    
    private let delayedTransition = DelayedWorkPerformer()
    
    /// Запланировать переход с задержкой
    /// - Parameters:
    ///   - delay: задержка
    ///   - transition: код перехода
    func performDelayedTransition(delay: TimeInterval, transition: @escaping () -> Void) {
        delayedTransition.perform(with: delay, work: transition)
    }
    
    /// Отменить запланированный переход
    func cancelDelayedTransition() {
        delayedTransition.delayedWork?.cancel()
    }
    
    /// Обработать переход, отложив его, если прошло недостаточно времени
    /// - Parameters:
    ///   - minPresentationTime: минимальное время, которое должно пройти для запуска перехода
    ///   - currentStatePresentationTime: сколько уже прошло времени
    ///   - transition: код перехода
    func processTransition(withMinPresentationTime minPresentationTime: TimeInterval,
                           currentStatePresentationTime: TimeInterval,
                           transition: @escaping () -> Void) {
        
        if currentStatePresentationTime < minPresentationTime {
            performDelayedTransition(delay: minPresentationTime - currentStatePresentationTime, transition: transition)
        }
        else {
            transition()
        }
    }
}

/// Условие для перехода из состояния отображения контента UI стейт машины
final class ContentStateChangeCondition: ViewStateChangeTransitionHandler, ViewStateChangeCondition {
    
    private let delay: TimeInterval
    private var isFirstLoadingTransition = true

    init(delay: TimeInterval = 0.1) {
        self.delay = delay
    }

    func setState<T>(_ state: ViewState<T>, with stateMachine: ViewStateMachine<T>) {
        
        cancelDelayedTransition()
        
        switch state {
            
        case .loading:
            
            if isFirstLoadingTransition {
                stateMachine.forceSetState(state)
            }
            else {
                
                performDelayedTransition(delay: delay) { [weak stateMachine] in
                    stateMachine?.forceSetState(state)
                }
            }
            
            isFirstLoadingTransition = false
            
        case .content, .empty, .error:
            stateMachine.forceSetState(state)
        }
    }
}

/// Условие для перехода из состояния отсутствия контента UI стейт машины
final class EmptyStateChangeCondition: ViewStateChangeTransitionHandler, ViewStateChangeCondition {
    
    private let delay: TimeInterval

    init(delay: TimeInterval = 0.1) {
        self.delay = delay
    }

    func setState<T>(_ state: ViewState<T>, with stateMachine: ViewStateMachine<T>) {
        
        cancelDelayedTransition()
        
        switch state {
            
        case .loading:
            
            performDelayedTransition(delay: delay) { [weak stateMachine] in
                stateMachine?.forceSetState(state)
            }
            
        case .content, .empty, .error:
            stateMachine.forceSetState(state)
        }
    }
}

/// Условие для перехода из состояния отображения ошибки получения контента UI стейт машины
final class ErrorStateChangeCondition: ViewStateChangeTransitionHandler, ViewStateChangeCondition {

    private let delay: TimeInterval

    init(delay: TimeInterval = 0.1) {
        self.delay = delay
    }

    func setState<T>(_ state: ViewState<T>, with stateMachine: ViewStateMachine<T>) {
        
        cancelDelayedTransition()
        
        switch state {
            
        case .loading:
            
            performDelayedTransition(delay: delay) { [weak stateMachine] in
                stateMachine?.forceSetState(state)
            }
            
        case .content, .empty, .error:
            stateMachine.forceSetState(state)
        }
    }
}

/// Условие для перехода из состояния загрузки контента UI стейт машины
final class LoadingStateChangeCondition: ViewStateChangeTransitionHandler, ViewStateChangeCondition {
    
    private let minPresentationTime: TimeInterval

    init(minPresentationTime: TimeInterval = 0.2) {
        self.minPresentationTime = minPresentationTime
    }

    func setState<T>(_ state: ViewState<T>, with stateMachine: ViewStateMachine<T>) {
        
        switch state {
            
        case .loading:
            return
            
        case .content, .empty, .error:
            
            processTransition(withMinPresentationTime: minPresentationTime,
                              currentStatePresentationTime: stateMachine.currentStatePresentationTime) { [weak stateMachine] in
                stateMachine?.forceSetState(state)
            }
        }
    }
}
