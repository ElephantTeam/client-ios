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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let coordinator = RootCoordinator(window: window)
        self.coordinator = coordinator
        coordinator.updateRootViewController()
        window.makeKeyAndVisible()
    }
}

class RootCoordinator {
    let window: UIWindow
    var didSeeOnboarding: Bool {
        get {
            UserDefaults.standard.bool(forKey: "didSeeOnboarding")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "didSeeOnboarding")
        }
    }
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func updateRootViewController() {
        if !didSeeOnboarding {
            let viewModel = OnboardingViewModel()
            viewModel.didSendName = { [weak self] in
                self?.didSeeOnboarding = true
                self?.updateRootViewController()
            }
            window.rootViewController = UIHostingController(rootView: OnboardingView(viewModel: viewModel))
        } else {
            window.rootViewController = UIHostingController(rootView: ContentView())
        }
    }
}
