//
//  Query.swift
//  DataWatch_NL_ESM WatchKit Extension
//
//  Created by Bradley Rey on 2021-06-17.
//

import Foundation

class Query {
    
    var query: String
    var activity: String
    var relatedToActivity: String
    var time: String
    var date: String
    
    init() {
        query = ""
        activity = ""
        relatedToActivity = ""
        time = ""
        date = ""
    }
    
    func setQuery (q: String) {
        query = q
    }
    
    func setActivity (ac: String) {
        activity = ac
    }
    
    func setRelatedToActivity (rta: String) {
        relatedToActivity = rta
    }
    
    func setTime (t: String) {
        time = t
    }
    
    func setDate (d: String) {
        date = d
    }
    
    func getQuery () -> String {
        return query
    }
    
    func getActivity () -> String {
        return activity
    }
    
    func getRelatedToActivity () -> String {
        return relatedToActivity
    }
    
    func getTime () -> String {
        return time
    }
    
    func getDate () -> String {
        return date
    }
    
    func queryAsString () -> String {
        return (query+","+activity+","+relatedToActivity+","+time+","+date)
    }
}
