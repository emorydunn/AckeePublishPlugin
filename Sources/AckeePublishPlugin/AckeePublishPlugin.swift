//
//  Ackee.swift
//
//
//  Created by Emory Dunn on 6/28/20.
//

import Foundation
import Publish
import Plot

/// Information used to configure the tracking script
public struct TrackerConfig {
    
    /// A shared instance
    public static var shared: TrackerConfig?
    
    /// Ackee server URL
    public var server: URL
    
    /// URL of the tracking script
    public var script: URL
    
    /// Domain ID for this website
    public var domainID: String
    
    /// Create a new tracker config.
    ///
    /// If no `script` URL is provided it defaults to `/tracker.js` at the root of the server URL.
    ///
    /// - Parameters:
    ///   - server: Ackee server URL
    ///   - domainID: URL of the tracking script
    ///   - script: Domain ID for this website
    public init(server: URL, domainID: String, script: URL? = nil) {
        self.server = server
        if let script = script {
            self.script = script
        } else {
            self.script = server.appendingPathComponent("tracker.js")
        }
        self.domainID = domainID
    }
    
    func ackeeTracker() -> Node<HTML.HeadContext> {
        .script(
            .async(),
            .src(script.absoluteString),
            .attribute(named: "data-ackee-server", value: server.absoluteString, ignoreIfValueIsEmpty: true),
            .attribute(named: "data-ackee-domain-id", value: domainID, ignoreIfValueIsEmpty: true)
            
        )
    }
    
    func ackeeSetup() -> Node<HTML.BodyContext> {
        .script(.src(script.absoluteString))
    }
    
    func manualTracker() -> Node<HTML.BodyContext> {
        .script(.raw("ackeeTracker.create('\(server.absoluteString)').record('\(domainID)')"))
    }
    
    func event<Event: Encodable>(eventID: String, payload: Event, encoder: JSONEncoder = JSONEncoder()) throws -> String {
        
        let data = try encoder.encode(payload)
        let dataString = String(data: data, encoding: .utf8)!
        
        return event(eventID: eventID, payload: dataString)
    }
    
    func event(eventID: String, payload: String) -> String {
        return "ackeeTracker.create('\(server.absoluteString)').action('\(eventID)', \(payload))"
    }
    
}
