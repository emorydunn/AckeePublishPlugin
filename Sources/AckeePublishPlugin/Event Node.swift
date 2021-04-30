//
//  Event Node.swift
//  
//
//  Created by Emory Dunn on 4/29/21.
//

import Foundation
import Publish
import Plot

public extension Node where Context == HTML.BodyContext {
    
    static func ackeeEvent<Event: Encodable>(selector: String, eventID: String, payload: Event, _ config: TrackerConfig? = TrackerConfig.shared) throws -> Node {
        guard let config = config else { return .empty }
        
        let action = try config.event(eventID: eventID, payload: payload)
        
        return ackeeEvent(selector: selector, eventID: eventID, payload: action)
        
    }
    
    static func ackeeEvent(selector: String, eventID: String, payload: String, _ config: TrackerConfig? = TrackerConfig.shared) -> Node {
        guard let config = config else { return .empty }
        
        let action = config.event(eventID: eventID, payload: payload)
        
        return .script(.raw("""
        document.querySelector('\(selector)').addEventListener('click', () => {
                \(action)
            })
        """))
        
    }

}
