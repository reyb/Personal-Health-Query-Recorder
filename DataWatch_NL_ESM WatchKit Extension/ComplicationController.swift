//
//  ComplicationController.swift
//  DataWatch_NL_ESM WatchKit Extension
//
//  Created by Bradley Rey on 2021-06-07.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    let defaults = UserDefaults.standard
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "Study", supportedFamilies: [CLKComplicationFamily.circularSmall, CLKComplicationFamily.graphicCircular, CLKComplicationFamily.graphicCorner, CLKComplicationFamily.modularSmall])
                    // Multiple complication support can be added here with more descriptors
                ]
            
            // Call the handler with the currently supported complication descriptors
            handler(descriptors)
        }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        if let template = getComplicationTemplate(for: complication, using: Date()) {
                    let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    handler(entry)
                } else {
                    handler(nil)
                }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // previously the code was:
        // This method will be called once per supported complication, and the results will be cached
//        handler(nil)
        
        let template = getComplicationTemplate(for: complication, using: Date())
                if let t = template {
                    handler(t)
                } else {
                    handler(nil)
                }
    }
    
    func getComplicationTemplate(for complication: CLKComplication, using date: Date) -> CLKComplicationTemplate? {
        let defaults = UserDefaults.standard
        let responseNum = (defaults.string(forKey: "numberOfResponses") ?? "")
        var complicationImage = ""
        // if the participant has given more than 50 responses (or an unforseen error occurs when casting string to int) then lets give them a smiley face
        if ((Int(responseNum) ?? 41) > 40) {
            complicationImage = "Complication/smiley"
        }
        else {
            complicationImage = (("Complication/")+responseNum)
        }
        
    
        switch complication.family {
        case .graphicCorner:
            return CLKComplicationTemplateGraphicCornerCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(named: complicationImage)!))
        case .graphicCircular:
            return CLKComplicationTemplateGraphicCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(named: complicationImage)!))
        case .circularSmall:
            return CLKComplicationTemplateCircularSmallSimpleImage(imageProvider: CLKImageProvider(onePieceImage: UIImage(named: complicationImage)!))
        case .modularSmall:
            return CLKComplicationTemplateModularSmallSimpleImage(imageProvider: CLKImageProvider(onePieceImage: UIImage(named: complicationImage)!))
        default:
            return nil
        }
    }
    
//    func createTemplate(for complication: CLKComplication, date: Date) -> CLKComplicationTemplate? {
//
//        switch (complication.family) {
//        case (.modularLarge):
//            return CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: CLKTextProvider(format: "Smartwatch Study"), body1TextProvider: CLKTextProvider(format: "You have" + String(defaults.integer(forKey: "numberOfResponses"))), body2TextProvider: CLKTextProvider(format: "responses!"))
//        case (_):
//             return nil
//       }
//    }
    
    func reloadActiveComplications() {
        let server = CLKComplicationServer.sharedInstance()

        for complication in server.activeComplications ?? [] {
            server.reloadTimeline(for: complication)
        }
    }
}
