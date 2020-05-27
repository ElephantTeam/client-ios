//
//  GameEngine.swift
//  instaaction
//
//  Created by Michał Apanowicz on 27/05/2020.
//  Copyright © 2020 Schibsted. All rights reserved.
//

import Foundation
import UserNotifications
import Combine 

final class GameEngine {
    private var cancelable: AnyCancellable?

    let userActions = "User Actions"

    let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
    let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])

    lazy var category = UNNotificationCategory(identifier: userActions, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])

    var activeChallenges: Set<Challenge> = []

    func start() {
        // TODO Better handling
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {_,_ in

        })

        cancelable = PushCheckService.shared.subject.sink { [weak self] value in
            // TODO Handle
        }
    }

    func scheduleNotification(for challange: Challenge) {
        print("scheduleNotification for \(challange)")

        let content = UNMutableNotificationContent()
        content.title = "New Challange!"
        content.body = challange.name
        content.sound = UNNotificationSound.default


        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: "identifier",
                                            content: content,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let err = error {
                print (err)
            }
        }
    }

}
