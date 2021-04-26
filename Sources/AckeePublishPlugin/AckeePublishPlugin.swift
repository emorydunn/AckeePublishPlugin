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
    
}

public extension Node where Context == HTML.HeadContext {
    
    static func ackeeTracker(_ config: TrackerConfig? = TrackerConfig.shared) -> Node {
        guard let config = config else { return .empty }
        
        return config.ackeeTracker()
        
    }
    
}

public extension Node where Context == HTML.DocumentContext {
    
    /// Add an HTML `<head>` tag within the current context, based
    /// on inferred information from the current location and `Website`
    /// implementation.
    /// - parameter location: The location to generate a `<head>` tag for.
    /// - parameter site: The website on which the location is located.
    /// - parameter titleSeparator: Any string to use to separate the location's
    ///   title from the name of the website. Default: `" | "`.
    /// - parameter stylesheetPaths: The paths to any stylesheets to add to
    ///   the resulting HTML page. Default: `styles.css`.
    /// - parameter rssFeedPath: The path to any RSS feed to associate with the
    ///   resulting HTML page. Default: `feed.rss`.
    /// - parameter rssFeedTitle: An optional title for the page's RSS feed.
    static func ackeeHead<T: Website>(
        for location: Location,
        on site: T,
        titleSeparator: String = " | ",
        stylesheetPaths: [Path] = ["/styles.css"],
        rssFeedPath: Path? = .defaultForRSSFeed,
        rssFeedTitle: String? = nil
    ) -> Node {
        var title = location.title
        
        if title.isEmpty {
            title = site.name
        } else {
            title.append(titleSeparator + site.name)
        }
        
        var description = location.description
        
        if description.isEmpty {
            description = site.description
        }
        
        return .head(
            .encoding(.utf8),
            .siteName(site.name),
            .url(site.url(for: location)),
            .title(title),
            .description(description),
            .twitterCardType(location.imagePath == nil ? .summary : .summaryLargeImage),
            .forEach(stylesheetPaths, { .stylesheet($0) }),
            .viewport(.accordingToDevice),
            .unwrap(site.favicon, { .favicon($0) }),
            .unwrap(rssFeedPath, { path in
                let title = rssFeedTitle ?? "Subscribe to \(site.name)"
                return .rssFeedLink(path.absoluteString, title: title)
            }),
            .unwrap(location.imagePath ?? site.imagePath, { path in
                let url = site.url(for: path)
                return .socialImageLink(url)
            }),
            .ackeeTracker()
        )
    }
    
}
