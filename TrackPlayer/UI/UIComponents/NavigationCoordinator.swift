//
//  NavigationCoordinator.swift
//  Portable
//

import UIKit

/// UINavigationController, который можно применять в качестве контейнера в координаторах
final class NavigationContainer: UINavigationController, CoordinatorContainer, UINavigationControllerDelegate {
    
    private lazy var containerLinks = CoordinatorContainerLinks()
    private var isPushingController = false
    private weak var proxyDelegate: UINavigationControllerDelegate?
    
    override var delegate: UINavigationControllerDelegate? {
        get { return proxyDelegate }
        set { proxyDelegate = newValue }
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        super.delegate = self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        super.delegate = self
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        super.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        super.delegate = self
    }
    
    // MARK: - CoordinatorContainer
    
    func link(coordinator: Coordinator) {
        containerLinks.link(coordinator: coordinator, to: self)
    }
    
    func link(coordinator: Coordinator, to view: UIViewController?) {
        containerLinks.link(coordinator: coordinator, to: view)
    }
    
    // MARK: - Открытые методы
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        isPushingController = true
        super.pushViewController(viewController, animated: animated)
    }
    
    // MARK: - Передача управления текущей ориентацией, видом статус бара итд самому верхнему контроллеру в стеке
    
    override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? super.prefersStatusBarHidden
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return topViewController?.preferredStatusBarUpdateAnimation ?? super.preferredStatusBarUpdateAnimation
    }
    
    override var childForHomeIndicatorAutoHidden: UIViewController? {
        return topViewController
    }
    
    override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        return topViewController
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        proxyDelegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        if isPushingController {
            isPushingController = false
        }
        else {
            containerLinks.clearDeadLinks()
        }
        
        proxyDelegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return proxyDelegate?.navigationControllerSupportedInterfaceOrientations?(navigationController) ?? .portrait
    }
    
    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        return proxyDelegate?.navigationControllerPreferredInterfaceOrientationForPresentation?(navigationController) ?? .portrait
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return proxyDelegate?.navigationController?(navigationController, interactionControllerFor: animationController)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return proxyDelegate?.navigationController?(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
    }
}

/// Координатор с контейнером типа NavigationContainer
class NavigationCoordinator: BaseCoordinator<NavigationContainer> {}
