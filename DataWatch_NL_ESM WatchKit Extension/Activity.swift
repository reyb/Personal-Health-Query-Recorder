//
//  ActivityTable.swift
//  DataWatch_NL_ESM WatchKit Extension
//
//  Created by Bradley Rey on 2021-06-16.
//

import WatchKit
import Foundation

/// The activities table screen interface controller.
class Activity: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func recordActivityButton() {
        // withSuggestions: none (this is if we wanted predefined possibilities)
        // allowedInputMode: speech and writing
        // completion: guard set to check if anything given
        self.presentTextInputController(withSuggestions: nil, allowedInputMode: .allowEmoji, completion: {results in
            guard let results = results else { return }
            // OperationQueue allows for updatingof text spoken in real time
            OperationQueue.main.addOperation {
                self.dismissTextInputController() // remove input controller when done
                //self.textToSpeechLabel.setText(results[0] as? String) // update label as String
                InterfaceController.GlobalVariable.query.setActivity(ac: results[0] as! String) // set query given in Query object
                // if a query is given then let's move to the next screen
                if (InterfaceController.GlobalVariable.query.getActivity() != ""){
                    self.pushController(withName: "RelatedToActivityScreen", context: nil) // push to next controller
                }
            }
        })
    }

}
