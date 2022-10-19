//
//  RelatedToActivity.swift
//  DataWatch_NL_ESM WatchKit Extension
//
//  Created by Bradley Rey on 2021-08-11.
//

import WatchKit
import Foundation

class RelatedToActivity: WKInterfaceController {
    @IBOutlet weak var table: WKInterfaceTable!
    let responses = ["Yes", "No"]
    let emojies = ["✓ ","ⅹ "]
    var relatedTo = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // set the number of rows in the table
        table.setNumberOfRows(responses.count, withRowType: "row")
        
        // configure cells
        for (index, response) in responses.enumerated() {
            // returns a TableRow element and fills it with text and image
            guard let row = table.rowController(at: index) as? TableRow else {continue}
            row.textLabel.setText(emojies[index]+response)
            row.setLabel(label: response)
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
    
    // function to handle when a row is clicked
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        // get the row that was clicked -> returns a TableRow
        let tempRow = table.rowController(at: rowIndex) as? TableRow
        // get the text of the cell
        let tempText = tempRow?.getLabel() ?? "default"
        // print to console the value
        print("Clicked on row: ",tempText)
        //change the background color to highlight selection
        
        // store the rows value in query object
        InterfaceController.GlobalVariable.query.setRelatedToActivity(rta: tempText)
        
        // set boolean to know which screen to push to
        if (tempText == "Yes") {
            relatedTo = true
        }
        
        pushNextScene(whichScreen: relatedTo)
    }
    
    @IBAction func pushNextScene(whichScreen: Bool) {
        // if question is related to activity then go to the time screen
        if whichScreen {
            self.pushController(withName: "TimeTableScreen", context: nil) // push to next controller
        }
        // else the question is not so we can go to the final screen
        else {
            self.pushController(withName: "FinalScreen", context: nil) // push to next controller
        }
    }

}
