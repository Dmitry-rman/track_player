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
        let screen = AboutView(output: output, title: String.pallete(.aboutButtonTitle))
        viewController = AboutViewController(rootView: screen)
    }
}
