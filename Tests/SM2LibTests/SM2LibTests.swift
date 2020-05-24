import XCTest
@testable import SM2Lib

final class SM2LibTests: XCTestCase {
    
    func testGradeDescription() {
        XCTAssertEqual(SM2Grade.null.description, "complete blackout")
        XCTAssertEqual(SM2Grade.bad.description, "incorrect response; the correct one remembered")
        XCTAssertEqual(SM2Grade.fail.description, "incorrect response; where the correct one seemed easy to recall")
        XCTAssertEqual(SM2Grade.pass.description, "correct response recalled with serious difficulty")
        XCTAssertEqual(SM2Grade.good.description, "correct response after a hesitation")
        XCTAssertEqual(SM2Grade.bright.description, "perfect response")
    }

    static var allTests = [
        ("testGradeDescription", testGradeDescription),
    ]
}
