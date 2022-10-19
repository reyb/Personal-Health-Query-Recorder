//
//  TimeTable.swift
//  DataWatch_NL_ESM WatchKit Extension
//
//  Created by Bradley Rey on 2021-06-16.
//

import WatchKit
import Foundation


class TimeTable: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    // array of times in the table
    let times = ["Before", "During", "After"]
    let emojies = ["🕘 ","🕛 ","🕒 "]
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here
        
        // set the number of rows in the table
        table.setNumberOfRows(times.count, withRowType: "row")
        
        // configure cells
        for (index, time) in times.enumerated() {
            // returns a TableRow element and fills it with text and image
            guard let row = table.rowController(at: index) as? TableRow else {continue}
            row.textLabel.setText(emojies[index]+time)
            row.setLabel(label: time)
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
        InterfaceController.GlobalVariable.query.setTime(t: tempText)
        
        pushNextScene()
    }
    
    // pushes to the defined screen
    @IBAction func pushNextScene() {
        // Do something before triggering the segue here.
            pushController(withName: "FinalScreen", context: nil)
    }

}
