//
//  IDScreen.swift
//  DataWatch_NL_ESM WatchKit Extension
//
//  Created by Bradley Rey on 2021-08-11.
//

import WatchKit
import Foundation

class ID: WKInterfaceController {
    
    @IBOutlet weak var idLabel: WKInterfaceLabel!
    @IBOutlet weak var numResponsesLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let defaults = UserDefaults.standard
        idLabel.setText("ID: " + defaults.string(forKey: "participantID")!)
        numResponsesLabel.setText ("Number of responses: " + String(defaults.integer(forKey: "numberOfResponses")))
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
