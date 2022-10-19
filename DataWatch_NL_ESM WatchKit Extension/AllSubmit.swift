//
//  AllSubmit.swift
//  DataWatch_NL_ESM WatchKit Extension
//
//  Created by Bradley Rey on 2021-08-11.
//

import WatchKit
import Foundation
import FirebaseDatabase

class AllSubmit: WKInterfaceController {
    
    private let database = Database.database().reference() // database
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func submitAllResponses() {
        print("Submitting all responses")
        
        let defaults = UserDefaults.standard
        let totalNumResponses = defaults.integer(forKey: "numberOfResponses")
        
        for i in 0...(totalNumResponses-1) {
            submit(responseNum: i)
        }
        
        print ("Done submitting responses")
    }
    
    func submit (responseNum: Int) {
        print ("Storing response " + String(responseNum))
        let defaults = UserDefaults.standard
        
        let query = defaults.string(forKey: ("response"+String(responseNum)+"query"))
        let activity = defaults.string(forKey: ("response"+String(responseNum)+"activity"))
        let relatedToActivity = defaults.string(forKey: ("response"+String(responseNum)+"relatedToActivity"))
        let time = defaults.string(forKey: ("response"+String(responseNum)+"time"))
        let date = defaults.string(forKey: ("response"+String(responseNum)+"date"))
        
        
        let QueryToSubmit: [String: Any] = [
            "id": defaults.string(forKey: "participantID")!,
            "query_number": responseNum,
            "query":  query ?? "ERROR: no query found",
            "activity":  activity ?? "ERROR: no activity found",
            "relatedToActivity":  relatedToActivity ?? "ERROR: no relatedToActivity found",
            "time":  time ?? "",
            "date":date ?? "ERROR: no date found",]
        
        let pID = String(defaults.string(forKey: "participantID")!)
        database.child(""+pID+"_"+String(responseNum)+"").setValue(QueryToSubmit)
    }
}
