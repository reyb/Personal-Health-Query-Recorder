//
//  InterfaceController.swift
//  DataWatch_NL_ESM WatchKit Extension
//
//  Created by Bradley Rey on 2021-06-07.
//

import WatchKit
import Foundation
import UserNotifications

/// The main screen interface controller. This allows users to immediately record data queries.
class InterfaceController: WKInterfaceController {
    
    let idLength = 7
    let minNotificationTime = 60
    let maxNotificationTime = 120
    
    struct GlobalVariable{ // data object to hold inputted elements for sending to server
        static var query = Query()
        }
    
    override func awake(withContext context: Any?) {
        print("in awake")
        // create an id the first time the application is opened
        let defaults = UserDefaults.standard
        
        // if setup is false (first time opening the app) then we need to do some setup
        if (defaults.bool(forKey: "setup") == false) {
            // create an id for the participant
            let id = createRandomID(length: idLength)
            defaults.set(id, forKey: "participantID")

            // set the number of responses to 0
            defaults.set(0, forKey: "numberOfResponses")

            // store that setup is done/true
            defaults.set(true, forKey: "setup")
            
            //ask for permission to show notifications
            requestNotificationAuthorization()
        }
        // end first time opening setup
        
    }
    
    override func willActivate() {
        let defaults = UserDefaults.standard
        // This method is called when watch view controller is about to be visible to user
        // setup a new instance of Query
        InterfaceController.GlobalVariable.query = Query()
        
        print("checking if notification times are setup...")
        if (defaults.string(forKey: "hourStart") != nil && defaults.string(forKey: "minuteStart") != nil && defaults.string(forKey: "ampmStart") != nil && defaults.string(forKey: "hourEnd") != nil && defaults.string(forKey: "minuteEnd") != nil && defaults.string(forKey: "ampmEnd") != nil) {
            print ("notification times setup by user...")
            print(defaults.bool(forKey: "notificationsSet"))
            if (defaults.bool(forKey: "notificationsSet") == false) {
                print("Setting up notifications..!")
                setupNotifications()
                defaults.set(true, forKey: "notificationsSet")
                
//                // create notifications
//                let manager = LocalNotificationManager()
//                manager.notifications = [
//                    LocalNotificationManager.Notification(id: "reminder-1", title: "Study Reminder", content: "Thanks for participating!", datetime: DateComponents(calendar: Calendar.current, year: 2021, month: 9, day: 15, hour: 7, minute: 00)),
//                    LocalNotificationManager.Notification(id: "reminder-2", title: "Study Reminder", content: "Thanks for participating!", datetime: DateComponents(calendar: Calendar.current, year: 2021, month: 9, day: 15, hour: 12, minute: 30)),
//                    LocalNotificationManager.Notification(id: "reminder-3", title: "Study Reminder", content: "Thanks for participating!", datetime: DateComponents(calendar: Calendar.current, year: 2021, month: 9, day: 15, hour: 16, minute: 35)),
//                    LocalNotificationManager.Notification(id: "reminder-4", title: "Study Reminder", content: "Thanks for participating!", datetime: DateComponents(calendar: Calendar.current, year: 2021, month: 9, day: 15, hour: 17, minute: 15))
//                ]
//
//                manager.schedule()
//                manager.listScheduledNotifications()
             
                
            }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    /**
        Initializes the text input controller upon clicking button on the main screen, stores the recorded query in a Query object, and pushes to the next screen when done.

         - Warning:
     
         - Parameters:

         - Returns:
     
    */
    @IBAction func recordQueryButton() {
        // withSuggestions: none (this is if we wanted predefined possibilities)
        // allowedInputMode: speech and writing
        // completion: guard set to check if anything given
        self.presentTextInputController(withSuggestions: nil, allowedInputMode: .allowEmoji, completion: {results in
            guard let results = results else { return }
            // OperationQueue allows for updatingof text spoken in real time
            OperationQueue.main.addOperation {
                self.dismissTextInputController() // remove input controller when done
                //self.textToSpeechLabel.setText(results[0] as? String) // update label as String
                GlobalVariable.query.setQuery(q: results[0] as! String) // set query given in Query object
                // if a query is given then let's move to the next screen
                if (GlobalVariable.query.getQuery() != ""){
                    self.pushController(withName: "ActivityScreen", context: nil) // push to next controller
                }
            }
        })
    }
    
    func createRandomID (length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
    
    func setupNotifications () {
        print("in setupNotications")
        // get current day and month
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dayMonthString = dateFormatter.string(from: Date())
        print("DayMonthString: "+dayMonthString)
        let dateArr = dayMonthString.components(separatedBy: "/")
        let currentDay = Int(dateArr[1])
        var currentMonth = Int(dateArr[0])
        
        // iterate for 8 (setup day + 7 study) days and create notifications for each day
        for i in 0...7 {
            let currentDayToUse = ((currentDay ?? 0) + i) % 30 // only setup to handle months with 30 days (September being one)
            // if a new month
            if (currentDayToUse == 1) {
                currentMonth = ((currentMonth ?? 0) + 1) % 12
            }
            
            // lets now create the notifications for this current day and month
            createNotificationTimesForDay (currentDay: (currentDayToUse), currentMonth: (currentMonth ?? 0))
        }
    }
    // end setupNotifications
    
    func createNotificationTimesForDay (currentDay: Int, currentMonth: Int) {
        // boolean to keep adding notifications for the day
        var moreNotificationsToday = true
        var stringID = ""
        // get user inputted start and end times
        let defaults = UserDefaults.standard

        let startHour = defaults.string(forKey: "hourStart") ?? ""
        let startMinute = defaults.string(forKey: "minuteStart") ?? ""
        let startAMPM = defaults.string(forKey: "ampmStart")
        
        var intStartHour = Int(startHour)
        let intStartMinute = Int(startMinute)

        // convert hour times to 24 hour clock if pm is selected
        if (startAMPM == "PM") {
            let tempStartHour = Int(startHour)
            if (tempStartHour != 12) {
                intStartHour = (tempStartHour ?? 0) + 12
            }
        }
        
        // setup the current hour and minute as the start hour and minute for the day
        var currentHour = intStartHour ?? 0
        var currentMinute = intStartMinute
        
        // create notifications
        let manager = LocalNotificationManager()
        manager.notifications = []
        
        // create the first notification for the day at the start time
        stringID = getID(currentDay: currentDay, currentMonth: currentMonth, currentHour: currentHour, currentMinute: currentMinute ?? 0)
        manager.notifications.append(LocalNotificationManager.Notification(id: stringID, title: "Study Reminder", content: "Do you have any questions or commands for your health data on your smartwatch?", datetime: DateComponents(calendar: Calendar.current, year: 2021, month: currentMonth, day: currentDay, hour: intStartHour, minute: intStartMinute)))
        
        while (moreNotificationsToday) {
            let newTime = getNewRandomTime(currentHour: currentHour, currentMinute: currentMinute ?? 0)
            if (validTime(currentHour: newTime.newHour, currentMinute: newTime.newMinute)) {
                currentHour = newTime.newHour
                currentMinute = newTime.newMinute
                stringID = getID(currentDay: currentDay, currentMonth: currentMonth, currentHour: currentHour, currentMinute: currentMinute ?? 0)
                manager.notifications.append(LocalNotificationManager.Notification(id: stringID, title: "Study Reminder", content: "Do you have any questions or commands for your health data on your smartwatch?", datetime: DateComponents(calendar: Calendar.current, year: 2021, month: currentMonth, day: currentDay, hour: currentHour, minute: currentMinute)))
            }
            else {
                moreNotificationsToday = false
            }
        }
        
        // schedule the created notifications for the day and print out the list
        manager.scheduleNotifications()
        //manager.listScheduledNotifications()
        
    }
    // end createNotificationTimesForDay
    
    func getNewRandomTime (currentHour: Int, currentMinute: Int) -> (newHour: Int, newMinute: Int) {
        let minsToAdd = (Int.random(in: minNotificationTime...maxNotificationTime))
        
        let newMinute = (currentMinute + minsToAdd) % 60
        var newHour = 0
        
        if ((currentMinute + minsToAdd) < 120) {
            newHour = (currentHour + 1) % 24
        }
        else {
            newHour = (currentHour + 2) % 24
        }
        
        return (newHour, newMinute)
            
    }
    // end getNewRandomTime
    
    func validTime (currentHour: Int, currentMinute: Int) -> Bool {
        var returnBool = false
        
        let defaults = UserDefaults.standard

        let startHour = defaults.string(forKey: "hourStart")
        let startMinute = defaults.string(forKey: "minuteStart") ?? ""
        let startAMPM = defaults.string(forKey: "ampmStart")
        let endHour = defaults.string(forKey: "hourEnd")
        let endMinute = defaults.string(forKey: "minuteEnd") ?? ""
        let endAMPM = defaults.string(forKey: "ampmEnd")

        var intStartHour = 0
        var intEndHour = 0
        let intStartMinute = Int(startMinute) ?? 0
        let intEndMinute = Int(endMinute) ?? 0

        // convert hour times to 24 hour clock if pm is selected
        if (startAMPM == "PM") {
            let tempStartHour = Int(startHour ?? "")
            if (tempStartHour != 12) {
                intStartHour = (tempStartHour ?? 0) + 12
                //print("start hour " + String(intStartHour))
            }
        }
        if (endAMPM == "PM") {
            let tempEndHour = Int(endHour ?? "")
            if (tempEndHour != 12) {
                intEndHour = (tempEndHour ?? 0) + 12
                //print("end hour " + String(intEndHour))
            }
        }
        
        if (currentHour > intStartHour && currentHour < intEndHour) {
            returnBool = true
        }
        else if (currentHour == intStartHour) {
            if (currentMinute >= intStartMinute) {
                returnBool = true
            }
        }
        else if (currentHour == intEndHour) {
            if (currentMinute <= intEndMinute) {
                returnBool = true
            }
        }

        return returnBool
    }
    // end validTime
    
    func getID (currentDay: Int, currentMonth: Int, currentHour: Int, currentMinute: Int) -> String {
        let stringDay = String(currentDay)
        let stringMonth = String(currentMonth)
        let stringHour = String(currentHour)
        let stringMinute = String(currentMinute)
        
        return ("Day:"+stringDay+"--Month:"+stringMonth+"--Hour:"+stringHour+"--Minute:"+stringMinute)
    }
    // end getID
    
    func requestNotificationAuthorization () {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {success, error in
            if success {
                // console print
                print ("notifications accepted")
            } // end if success
            else if let error = error {
                print(error.localizedDescription)
            }
        } // end notifcation permission
    }
}
