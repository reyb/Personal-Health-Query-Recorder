//
//  LocalNotificationManager.swift
//  DataWatch_NL_ESM WatchKit Extension
//
//  Created by Bradley Rey on 2021-09-14.
//

import Foundation
import WatchKit
import UserNotifications

class LocalNotificationManager {
    
    var notifications = [Notification]()
    
    struct Notification {
        var id: String
        var title: String
        var content: String
        var datetime: DateComponents
    }
    
    func listScheduledNotifications()
    {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in

            for notification in notifications {
                print("notification: " + notification.identifier)
            }
        }
    }
    
    private func requestAuthorization()
    {
        print("getting authorization")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }
    
    func schedule()
    {
        UNUserNotificationCenter.current().getNotificationSettings { settings in

            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }
    
    func scheduleNotifications()
    {
        for notification in notifications
        {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.subtitle = notification.content
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in

                guard error == nil else { return }

                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }


}
