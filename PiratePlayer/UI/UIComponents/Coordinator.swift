//
//  Coordinator.swift
//  Portable
//

import UIKit

/// Контейнер, в котором координатор отображает модули
protocol CoordinatorContainer: AnyObject {
    
    /// Связать lifecycle координатора с lifecycle контейнера
    /// - Parameters:
    ///   - coordinator: координатор
    func link(coordinator: Coordinator)
    
    /// Связать lifecycle координатора с lifecycle конкретного UIViewController
    /// - Parameters:
    ///   - coordinator: координатор
    ///   - view: конкретный UIViewController
    func link(coordinator: Coordinator, to view: UIViewController?)
}

/// Базовый интерфейс, которому должны следовать все координаторы
protocol Coordinator: AnyObject {
    
    /// Блок обработки завершения работы координатора, входящий параметр - сам координатор
    typealias CoordinatorCompletionHandler = ((Coordinator) -> ())
    
    /// Вызывается при завершении работы координатора, нужно для того, чтобы выполнить некую логику по завершении story координатора
    var completionHandler: CoordinatorCompletionHandler? { get set }
    
    /// Контейнер, в котором координатор отображает модули
    var coordinatorContainer: CoordinatorContainer? { get }
    
    /// Метод начала работы координатора, запускает показ story координатора
    /// - Parameters:
    ///   - animated: надо ли применять анимацию при возможности
    /// - Returns: показанный UIViewController
    @discardableResult
    func start(animated: Bool) -> UIViewController
}

/// Базовая реализация координатора (абстрактный класс)
class BaseCoordinator<Container: CoordinatorContainer>: NSObject, Coordinator {
    
    /// Контейнер, в котором координатор отображает модули
    private(set) weak var container: Container?
    
    /// Создать координатор с контейнером
    /// - Parameter container: контейнер
    init(container: Container?) {
        self.container = container
    }
    
    // MARK: - Coordinator
    
    var completionHandler: CoordinatorCompletionHandler?
     
    var coordinatorContainer: CoordinatorContainer? {
        return container
    }
    
    @discardableResult
    func start(animated: Bool) -> UIViewController {
        fatalError("Необходимо реализовать в наследнике!")
    }
}
