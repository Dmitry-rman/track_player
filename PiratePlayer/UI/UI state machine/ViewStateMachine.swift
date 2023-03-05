//
//  ViewStateMachine.swift
//  Portable
//

import Combine
import Foundation

/// UI стейт машина
final class ViewStateMachine<T>: ObservableObject {
    
    /// Текущее состояние
    @Published private(set) var state: ViewState<T>

    /// Условие для перехода из состояния загрузки контента
    var loadingCondition: ViewStateChangeCondition
    
    /// Условие для перехода из состояния отображения контента
    var contentCondition: ViewStateChangeCondition
    
    /// Условие для перехода из состояния отсутствия контента
    var emptyCondition: ViewStateChangeCondition
    
    /// Условие для перехода из состояния отображения ошибки получения контента
    var errorCondition: ViewStateChangeCondition
    
    /// Длительность отображения текущего состояния
    var currentStatePresentationTime: TimeInterval {
        Date().timeIntervalSince(stateSetupTime)
    }
    
    private var stateSetupTime = Date()
    
    /// Создать UI стейт машину
    /// - Parameters:
    ///   - state: исходное состояние
    ///   - loadingCondition: условие для перехода из состояния загрузки контента
    ///   - contentCondition: условие для перехода из состояния отображения контента
    ///   - emptyCondition: условие для перехода из состояния отсутствия контента
    ///   - errorCondition: условие для перехода из состояния отображения ошибки получения контента
    init(_ state: ViewState<T>,
         loadingCondition: ViewStateChangeCondition = LoadingStateChangeCondition(),
         contentCondition: ViewStateChangeCondition = ContentStateChangeCondition(),
         emptyCondition: ViewStateChangeCondition = EmptyStateChangeCondition(),
         errorCondition: ViewStateChangeCondition = ErrorStateChangeCondition()) {
        self.state = state
        self.loadingCondition = loadingCondition
        self.contentCondition = contentCondition
        self.emptyCondition = emptyCondition
        self.errorCondition = errorCondition
    }
    
    /// Установить новое состояние, соблюдая условия
    /// - Parameter state: новое состояние
    func setState(_ state: ViewState<T>) {
        
        stateSetupTime = Date()
        
        switch self.state {
        case .loading:
            loadingCondition.setState(state, with: self)
        case .content:
            contentCondition.setState(state, with: self)
        case .empty:
            emptyCondition.setState(state, with: self)
        case .error:
            errorCondition.setState(state, with: self)
        }
    }
    
    /// Установить новое состояние, игнорируя условия
    /// - Parameter state: новое состояние
    func forceSetState(_ state: ViewState<T>) {
        stateSetupTime = Date()
        self.state = state
    }
}

