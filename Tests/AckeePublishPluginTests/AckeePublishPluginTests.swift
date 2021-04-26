import XCTest
import Publish
import Plot
@testable import AckeePublishPlugin


final class AckeePublishPluginTests: XCTestCase {
    func testAutoTrackerURL() {
        
        TrackerConfig.shared = TrackerConfig(server: URL(string: "https://analytics.example.com")!,
                                             domainID: "test-id")
        
        let config = TrackerConfig(server: URL(string: "https://analytics.example.com")!, domainID: "test-id")
        
        let trackerHTML = #"<script async src="https://analytics.example.com/tracker.js" data-ackee-server="https://analytics.example.com" data-ackee-domain-id="test-id"></script>"#

        XCTAssertEqual(config.ackeeTracker().render(), trackerHTML)
        
    }
    
    func testManualTrackerURL() {
        let config = TrackerConfig(
            server: URL(string: "https://analytics.example.com")!,
            domainID: "test-id",
            script: URL(string: "https://analytics.example.com/customscript.js")!
        )
        
        let trackerHTML = #"<script async src="https://analytics.example.com/customscript.js" data-ackee-server="https://analytics.example.com" data-ackee-domain-id="test-id"></script>"#
        
        XCTAssertEqual(config.ackeeTracker().render(), trackerHTML)
        
    }

    static var allTests = [
        ("testAutoTrackerURL", testAutoTrackerURL),
        ("testManualTrackerURL", testManualTrackerURL)
    ]
}
