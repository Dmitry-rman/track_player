//
//  AboutViewModule.swift
//  TrackPlayer
//
//  Created by Dmitry on 13.03.2023.
//

import UIKit

protocol AboutViewModuleOutput: AnyObject {
    func aboutDidClosed()
}

struct AboutViewModule: ViewModuleProtocol {
    private var viewController: AboutViewController
    
    /// Visual representation of module
    var view: UIViewController {
        viewController
    }
    
    init(output: AboutViewModuleOutput, container: DiContainer) {
        viewController = AboutViewController(rootView: AboutView(output: output))
    }
}
