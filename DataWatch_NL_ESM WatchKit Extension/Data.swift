//
//  Data.swift
//  DataWatch_NL_ESM WatchKit Extension
//
//  Created by Bradley Rey on 2021-06-16.
//

import Foundation

class Data {
    
    var allDataArray: Array<Query>
    
    init() {
        allDataArray = Array()
    }
    
    func getQueryAtIndex (i: Int) -> Query {
        return allDataArray[i]
    }
    
    // prepares the entire array of query objects into a large String for export
    func prepareDataForExport () -> String {
        var returnString = ""
        // loop through allDataArray
        for (index, query) in allDataArray.enumerated() {
            //returnString = returnString + id
            returnString = returnString + (query.queryAsString())
            // if not the last query then add a new line for next query
            if (index != allDataArray.count - 1) {
                returnString = returnString + "\n"
            }
        }
        return returnString
    }
}
