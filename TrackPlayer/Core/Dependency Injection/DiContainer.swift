//
//  DIConttainer.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

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
    
    let appState: Store<AppState> = Store(AppState())
    
    /// Текущий закэшированный строитель сервисов
    fileprivate static var currentServiceBuilder: ServiceBuilder!
    
    /// Создаем строитель сервисов согласно текущей конфигурации сервисов
    fileprivate func createServiceBuilder() -> ServiceBuilder {
        
        switch buildConfiguration{
        case .testing:
            return ServiceBuilderMock()
        case .prod:
            return ServiceBuilderProd(shouldLogNetworkRequests: false)
        default:
            return ServiceBuilderDebug(shouldLogNetworkRequests: true)
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

}

#if DEBUG
extension DiContainer {
    
    static var preview: DiContainer {
        return DiContainer.init(buildConfiguration: .testing)
    }
}
#endif
