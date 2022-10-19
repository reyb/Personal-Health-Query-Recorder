//
//  NotificationController.swift
//  DataWatch_NL_ESM WatchKit Extension
//
//  Created by Bradley Rey on 2021-06-07.
//

import WatchKit
import Foundation
import UserNotifications

class NotificationController: WKUserNotificationInterfaceController {

    @IBOutlet weak var notificationLabel: WKInterfaceLabel! // label for dynamic notification
    let notificationPossibilities = ["Do you have any questions/commands of your data?", "Any questions/commands of your health data?", "Just a friendly reminder to think about anything you may want to ask or say of your health data on your smartwatch!","Are there questions/commands that would help motivate you?", "Do you have questions/commands that would let you explore your data better?", "Thanks for participating in our study!"] // notification label possibilities
    
    
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    override func didReceive(_ notification: UNNotification) {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        
        // choose dynamic notification
        let notification = (Int.random(in: 0..<notificationPossibilities.count)) // get an array location for specific notification text
        notificationLabel.setText(notificationPossibilities[notification]) // set notification lable to chosen text
    }
    
}
