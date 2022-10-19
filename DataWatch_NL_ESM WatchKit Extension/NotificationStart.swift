//
//  NotificationStart.swift
//  DataWatch_NL_ESM WatchKit Extension
//
//  Created by Bradley Rey on 2021-08-11.
//

import WatchKit
import Foundation

class NotificationStart: WKInterfaceController {
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    @IBOutlet weak var hourPicker: WKInterfacePicker!
    @IBOutlet weak var minutePicker: WKInterfacePicker!
    @IBOutlet weak var ampmPicker: WKInterfacePicker!
    
    var hour = ""
    var minute = ""
    var ampm = ""
    
    var hourList: [(String, String)] = [
            ("Item 1", "1"),
            ("Item 2", "2"),
            ("Item 3", "3"),
            ("Item 4", "4"),
            ("Item 5", "5"),
            ("Item 6", "6"),
            ("Item 7", "7"),
            ("Item 8", "8"),
            ("Item 9", "9"),
            ("Item 10", "10"),
            ("Item 11", "11"),
            ("Item 12", "12")]
    
    var minuteList: [(String, String)] = [
            ("Item 1", "00"),
            ("Item 2", "15"),
            ("Item 3", "30"),
            ("Item 4", "45")]
    
    var ampmList: [(String, String)] = [
            ("Item 1", "AM"),
            ("Item 2", "PM")]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        resetTimeLabel()
        
        let pickerItemsHour: [WKPickerItem] = hourList.map {
            let pickerItem = WKPickerItem()
            pickerItem.caption = $0.0
            pickerItem.title = $0.1
            return pickerItem
        }
        hourPicker.setItems(pickerItemsHour)
        
        let pickerItemsMinute: [WKPickerItem] = minuteList.map {
            let pickerItem = WKPickerItem()
            pickerItem.caption = $0.0
            pickerItem.title = $0.1
            return pickerItem
        }
        minutePicker.setItems(pickerItemsMinute)
        
        let pickerItemsAMPM: [WKPickerItem] = ampmList.map {
            let pickerItem = WKPickerItem()
            pickerItem.caption = $0.0
            pickerItem.title = $0.1
            return pickerItem
        }
        ampmPicker.setItems(pickerItemsAMPM)
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //TODO: store values to userdefaults
    @IBAction func hourPickerChanged(_ value: Int) {
        hour = hourList[value].1
        defaults.set(hour, forKey: "hourStart")
        resetTimeLabel()
    }
    
    @IBAction func minutePickerChanged(_ value: Int) {
        minute = minuteList[value].1
        defaults.set(minute, forKey: "minuteStart")
        resetTimeLabel()
    }
    
    @IBAction func ampmPickerChanged(_ value: Int) {
        ampm = ampmList[value].1
        defaults.set(ampm, forKey: "ampmStart")
        resetTimeLabel()
    }
    
    func resetTimeLabel () {
        let thisHour = defaults.string(forKey: "hourStart") ?? ""
        let thisMinute = defaults.string(forKey: "minuteStart") ?? ""
        let thisAMPM = defaults.string(forKey: "ampmStart") ?? ""
        timeLabel.setText("Notifications will start at " + thisHour + ":" + thisMinute + " " + thisAMPM)
    }
    
}
