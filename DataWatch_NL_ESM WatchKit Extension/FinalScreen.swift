//
//  FinalScreen.swift
//  DataWatch_NL_ESM WatchKit Extension
//
//  Created by Bradley Rey on 2021-06-16.
//

import WatchKit
import Foundation
import FirebaseDatabase

class FinalScreen: WKInterfaceController {

    @IBOutlet var overview: WKInterfaceLabel! // label to overview the data entered
    private let database = Database.database().reference() // database
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // show the participant what they have entered
        // if physical activity selected, then there is an extra data point to show
        if (InterfaceController.GlobalVariable.query.getRelatedToActivity()=="Yes") {
            overview.setText("Question: "+InterfaceController.GlobalVariable.query.getQuery()+"\nActivity: "+InterfaceController.GlobalVariable.query.getActivity()+"\nRelated To Activity: "+InterfaceController.GlobalVariable.query.getRelatedToActivity()+"\nTime: "+InterfaceController.GlobalVariable.query.getTime())
        }
        else {
            overview.setText("Question: "+InterfaceController.GlobalVariable.query.getQuery()+"\nActivity: "+InterfaceController.GlobalVariable.query.getActivity()+"\nRelated To Activity: "+InterfaceController.GlobalVariable.query.getRelatedToActivity())
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // when submit button tapped we do three things as well as some background updating
    // 1. send data to firebase database
    // 2. store data to local file (for redundancy)
    // 3. update overall query number (used in key value so always unique)
    @IBAction func submitButtonTapped() {
        let defaults = UserDefaults.standard
        // set the date of the query made
        InterfaceController.GlobalVariable.query.setDate(d: createDate())
        // prepare object to be submitted to firebase database
        let QueryToSubmit: [String: Any] = [
            "id": defaults.string(forKey: "participantID")!,
            "query_number": defaults.integer(forKey: "numberOfResponses"),
            "query":  InterfaceController.GlobalVariable.query.getQuery(),
            "activity":  InterfaceController.GlobalVariable.query.getActivity(),
            "relatedToActivity":  InterfaceController.GlobalVariable.query.getRelatedToActivity(),
            "time":  InterfaceController.GlobalVariable.query.getTime(),
            "date": InterfaceController.GlobalVariable.query.getDate(),]
        
        // add query to firebase database
        let pID = String(defaults.string(forKey: "participantID")!)
        let responseNum = String(defaults.integer(forKey: "numberOfResponses"))
        database.child(""+pID+"_"+responseNum+"").setValue(QueryToSubmit)
        
        // add query to userdefaults for redundancy - added with key "responseX" where X is the current query number
        let queryKey = ("response" + responseNum + "query")
        let activityKey = ("response" + responseNum + "activity")
        let relatedToActivityKey = ("response" + responseNum + "relatedToActivity")
        let timeKey = ("response" + responseNum + "time")
        let dateKey = ("response" + responseNum + "date")
        defaults.set(InterfaceController.GlobalVariable.query.getQuery(), forKey: queryKey)
        defaults.set(InterfaceController.GlobalVariable.query.getActivity(), forKey: activityKey)
        defaults.set(InterfaceController.GlobalVariable.query.getRelatedToActivity(), forKey: relatedToActivityKey)
        defaults.set(InterfaceController.GlobalVariable.query.getTime(), forKey: timeKey)
        defaults.set(InterfaceController.GlobalVariable.query.getDate(), forKey: dateKey)
        
        // update query number
        updateQueryNumber()
        
        // update complication
        let compController = ComplicationController ()
        compController.reloadActiveComplications()
        
        // go back home
        goHome()
    }
    
    // pushes to the defined screen
    func goHome() {
        popToRootController()
    }
    
    func updateQueryNumber () {
        let defaults = UserDefaults.standard
        let currentResponseCount = defaults.integer(forKey: "numberOfResponses")
        defaults.set(currentResponseCount+1, forKey: "numberOfResponses")
    }
    
    func createDate () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_hh:mm"
        
        return (dateFormatter.string(from: Date()))
    }
}
