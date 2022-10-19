//
//  TableRow.swift
//  DataWatch_NL_ESM WatchKit Extension
//
//  Created by Bradley Rey on 2021-06-16.
//

import WatchKit

/// Provides a class for each row in a table.
class TableRow: NSObject {

    @IBOutlet var textLabel: WKInterfaceLabel! // label in the row of the table
    var textLabelString: String! // String value of the label in the table. Used for debugging and storing of data
    
    // function to return the row's string label value
    func getLabel () -> String {
        return textLabelString
    }
    
    // function to set the row's string label variable
    func setLabel (label: String) {
        textLabelString = label
    }
}
