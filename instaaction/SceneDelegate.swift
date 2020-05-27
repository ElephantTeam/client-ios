//
//  SceneDelegate.swift
//  instaaction
//
//  Created by Michał Apanowicz on 27/05/2020.
//  Copyright © 2020 Schibsted. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: RootCoordinator?
    let game = GameEngine()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let coordinator = RootCoordinator(window: window)
        self.coordinator = coordinator
        coordinator.updateRootViewController()
        window.makeKeyAndVisible()

        game.start()
    }
}

class RootCoordinator {
    let window: UIWindow
    
    var didSeeOnboarding: Bool {
        UserDefaultsConfig.userName != nil
    }
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func updateRootViewController() {
        if !didSeeOnboarding {
            let viewModel = OnboardingViewModel()
            viewModel.didSaveName = { [weak self] in
                self?.updateRootViewController()
            }
            window.rootViewController = UIHostingController(rootView: OnboardingView(viewModel: viewModel))
        } else {
            window.rootViewController = UIHostingController(rootView: AppView(homeStore: HomeStore()))
        }
    }
}
