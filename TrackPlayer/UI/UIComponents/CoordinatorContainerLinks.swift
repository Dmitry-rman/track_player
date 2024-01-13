//
//  CoordinatorContainerLinks.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation
import UIKit

/// Менеджер хранения ссылок на координаторы, используемый в контейнерах, чтобы связать lifecycle координаторов с lifecycle конкретных UIViewController
final class CoordinatorContainerLinks {
    /// Класс-хелпер для создания ключа со слабой ссылкой на конкретный UIViewController
    private final class ViewWeakLink: Hashable {
        
        let precomputedHash: Int
        weak var viewController: UIViewController?
        
        init(view: UIViewController) {
            precomputedHash = view.hashValue
            viewController = view
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(precomputedHash)
        }
        
        typealias WeakLink = CoordinatorContainerLinks.ViewWeakLink
        
        static func == (lhs: WeakLink, rhs: WeakLink) -> Bool {
            return lhs.precomputedHash == rhs.precomputedHash
        }
    }
    
    /// Ссылки на координаторы, которые "держит" контейнер
    private lazy var links = [ViewWeakLink : Coordinator]()
    
    /// Serial очередь, на которой синхронизирован доступ к links
    private lazy var linksSerializationQueue = DispatchQueue(label: "com.any.app.coordinator.links.handling", qos: .userInitiated)
    
    // MARK: - Открытые методы
    
    /// Связать lifecycle координатора с lifecycle конкретного UIViewController
    /// - Parameters:
    ///   - coordinator: координатор
    ///   - view: конкретный UIViewController
    func link(coordinator: Coordinator, to view: UIViewController?) {
        guard let view = view else { return }

        linksSerializationQueue.async { [weak self] in
            
            guard let self = self else { return }
            
            let link = ViewWeakLink(view: view)
            self.links[link] = coordinator
        }
    }
    
    /// Очистить ссылки на координаторы, чьи UIViewController уже "умерли"
    func clearDeadLinks() {
        guard !links.isEmpty else { return }
        
        linksSerializationQueue.async { [weak self] in
            guard let self = self else { return }
            self.links = self.links.filter({ $0.key.viewController != nil })
        }
    }
}
