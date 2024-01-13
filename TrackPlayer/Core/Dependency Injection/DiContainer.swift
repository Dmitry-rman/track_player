//
//  DIConttainer.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation
import SwiftUI

/// Контейнер для dependency injection
final class DiContainer {
    /// Конфигурация сборки
    ///
    /// - debug: отладка
    /// - release: боевая
    enum BuildConfiguration: String {
        case debug
        case prod
        case testing
    }
    
    /// Текущая конфигурация сборки
    let buildConfiguration: BuildConfiguration
    
    init(buildConfiguration: BuildConfiguration) {
        
        self.buildConfiguration = buildConfiguration
    }
    
    //MARK: - ServiceBuilder
    
    /// Строитель сервисов, для получения экземпляров сервисов в любом месте приложения надо обращаться к нему
    var serviceBuilder: ServiceBuilder {
        createServiceBuilderIfNeeded()
        return Self.currentServiceBuilder
    }
    
    lazy var appState: Store<AppState> = {
        return Store(AppState(userData: UserData.init()))
    }()
    
    /// Текущий закэшированный строитель сервисов
    fileprivate static var currentServiceBuilder: ServiceBuilder!
    
    /// Создаем строитель сервисов согласно текущей конфигурации сервисов
    fileprivate func createServiceBuilder() -> ServiceBuilder {
        switch buildConfiguration{
        case .testing:
            return ServiceBuilderMock()
        case .prod:
            return ServiceBuilderProd(shouldLogNetworkRequests: false, stateChanger: self)
        default:
            return ServiceBuilderDebug(shouldLogNetworkRequests: true, stateChanger: self)
        }
    }
    
    /// Пересоздаем строитель сервисов согласно текущей конфигурации сервисов, если это необходимо
    fileprivate func createServiceBuilderIfNeeded() {
        // если строитель еще не определен, то просто создаем его
        guard Self.currentServiceBuilder != nil else {
            Self.currentServiceBuilder = createServiceBuilder()
            return
        }
    }
    
    lazy var player: TrackPlayer = {
        self.serviceBuilder.createPlayer()
    }()
}

extension DiContainer: IStateChange {
    func favoritsChanged(_ value: Int) {
        appState.bulkUpdate({ state in
            state.userData.favoritsCount = value
        })
    }
}
