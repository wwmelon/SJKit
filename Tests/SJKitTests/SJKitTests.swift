import XCTest
@testable import SJKit

final class SJKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SJKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
