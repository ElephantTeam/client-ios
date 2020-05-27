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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        let shouldShowOnboarding = true // TODO: Implement it
//        if shouldShowOnboarding {
//            startView = OnboardingView()
//        } else {
//            startView = ContentView()
//        }
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: OnboardingView())
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
