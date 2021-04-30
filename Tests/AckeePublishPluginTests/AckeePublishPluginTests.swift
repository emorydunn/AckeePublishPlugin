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
    
    func testEvent() throws {
        let config = TrackerConfig(
            server: URL(string: "https://analytics.example.com")!,
            domainID: "test-event-id"
        )
        
        let trackerHTML = """
        <!DOCTYPE html>
        <html>
            <body>
                <script src="https://analytics.example.com/tracker.js"></script>
                <script>document.querySelector('#download').addEventListener('click', () => {
                ackeeTracker.create('https://analytics.example.com').action('test-event-id', { key: 'Click', value: '1' })
            })</script>
            </body>
        </html>
        """
        
        let html = HTML(
            .body(
                .ackeeSetup(config),
                .ackeeEvent(selector: "#download", eventID: "test-event-id", payload: "{ key: 'Click', value: '1' }")
            )
        )
        
        XCTAssertEqual(html.render(indentedBy: .spaces(4)), trackerHTML)
    }

    static var allTests = [
        ("testAutoTrackerURL", testAutoTrackerURL),
        ("testManualTrackerURL", testManualTrackerURL)
    ]
}
