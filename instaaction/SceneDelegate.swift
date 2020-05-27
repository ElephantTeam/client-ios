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
        UNUserNotificationCenter.current().delegate = self

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

extension SceneDelegate: UNUserNotificationCenterDelegate {
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let challengeIdentifier = response.notification.request.identifier
        guard let challenge = game.activeChallenges.first(where: { String($0.id) == challengeIdentifier }) else {
            coordinator?.presentError()
            return
        }
        coordinator?.presentChallenge(challenge)
    }
}

class RootCoordinator {
    let window: UIWindow
    
    var didSeeOnboarding: Bool {
        UserDefaultsConfig.user != nil
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

    func presentChallenge(_ challenge: Challenge) {
        window.rootViewController?.dismiss(animated: true, completion: nil)
        let hosting = UIHostingController(rootView: ChallengeView(challange: challenge))
        window.rootViewController?.present(hosting, animated: true, completion: nil)
    }

    func presentError() {
        // TODO handle error
    }
}
