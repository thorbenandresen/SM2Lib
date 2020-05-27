import XCTest
@testable import SM2Lib

final class SM2LibTests: XCTestCase {

    static let defaultRepetion = 0
    static let defaultInterval = 0
    static let defaultEasinessFactor = 2.5
    static let october_23_2016 = 1477207892.0
    static let defaultCardParameter = SM2CardParameter(repetition: defaultRepetion, interval: defaultInterval, easinessFactor: defaultEasinessFactor, previousDate: october_23_2016, nextDate: october_23_2016)

    func testGradeDescription() {
        XCTAssertEqual(SM2Grade.null.description, "complete blackout")
        XCTAssertEqual(SM2Grade.bad.description, "incorrect response; the correct one remembered")
        XCTAssertEqual(SM2Grade.fail.description, "incorrect response; where the correct one seemed easy to recall")
        XCTAssertEqual(SM2Grade.pass.description, "correct response recalled with serious difficulty")
        XCTAssertEqual(SM2Grade.good.description, "correct response after a hesitation")
        XCTAssertEqual(SM2Grade.bright.description, "perfect response")
    }

    func testCardParameter() {

        let actual = SM2LibTests.defaultCardParameter
        XCTAssertEqual(actual.repetition, SM2LibTests.defaultRepetion)
        XCTAssertEqual(actual.interval, SM2LibTests.defaultInterval)
        XCTAssertEqual(actual.easinessFactor, SM2LibTests.defaultEasinessFactor)

    }

    func testgrade_0_response() {
        let sm2grade = SM2Grade.null
        let expectedEasinessFactor = SM2LibTests.defaultEasinessFactor
        let cardParameter = SM2LibTests.defaultCardParameter
        let newCardParameter = SM2Engine.gradeFlashCard(cardParameter: cardParameter, grade: sm2grade, currentDatetime: SM2LibTests.october_23_2016)

        XCTAssertEqual(newCardParameter.repetition, SM2LibTests.defaultRepetion)
        XCTAssertEqual(newCardParameter.interval, SM2LibTests.defaultInterval)
        XCTAssertEqual(newCardParameter.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newCardParameter.previousDate, SM2LibTests.october_23_2016)
        XCTAssertEqual(newCardParameter.nextDate, SM2LibTests.october_23_2016)
    }

    func testgrade_1_response() {
        let sm2grade = SM2Grade.bad
        let expectedEasinessFactor = SM2LibTests.defaultEasinessFactor
        let cardParameter = SM2LibTests.defaultCardParameter
        let newCardParameter = SM2Engine.gradeFlashCard(cardParameter: cardParameter, grade: sm2grade, currentDatetime: SM2LibTests.october_23_2016)

        XCTAssertEqual(newCardParameter.repetition, SM2LibTests.defaultRepetion)
        XCTAssertEqual(newCardParameter.interval, SM2LibTests.defaultInterval)
        XCTAssertEqual(newCardParameter.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newCardParameter.previousDate, SM2LibTests.october_23_2016)
        XCTAssertEqual(newCardParameter.nextDate, SM2LibTests.october_23_2016)
    }

    func testgrade_2_response() {
        let sm2grade = SM2Grade.bad
        let expectedEasinessFactor = SM2LibTests.defaultEasinessFactor
        let cardParameter = SM2LibTests.defaultCardParameter
        let newCardParameter = SM2Engine.gradeFlashCard(cardParameter: cardParameter, grade: sm2grade, currentDatetime: SM2LibTests.october_23_2016)

        XCTAssertEqual(newCardParameter.repetition, SM2LibTests.defaultRepetion)
        XCTAssertEqual(newCardParameter.interval, SM2LibTests.defaultInterval)
        XCTAssertEqual(newCardParameter.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newCardParameter.previousDate, SM2LibTests.october_23_2016)
        XCTAssertEqual(newCardParameter.nextDate, SM2LibTests.october_23_2016)
    }

    func testgrade_3_response() {
        let sm2grade = SM2Grade.pass
        let expectedEasinessFactor = 2.36
        let cardParameter = SM2LibTests.defaultCardParameter
        let newCardParameter = SM2Engine.gradeFlashCard(cardParameter: cardParameter, grade: sm2grade, currentDatetime: SM2LibTests.october_23_2016)

        XCTAssertEqual(newCardParameter.repetition, 1)
        XCTAssertEqual(newCardParameter.interval, SM2LibTests.defaultInterval)
        XCTAssertEqual(newCardParameter.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newCardParameter.previousDate, SM2LibTests.october_23_2016)
        XCTAssertEqual(newCardParameter.nextDate, SM2LibTests.october_23_2016)
    }

    func testgrade_4_response() {
        let sm2grade = SM2Grade.good
        let oneDay = 86400.0
        let october_24_2016 = SM2LibTests.october_23_2016 + oneDay
        let expectedEasinessFactor = SM2LibTests.defaultEasinessFactor
        let cardParameter = SM2LibTests.defaultCardParameter
        let newCardParameter = SM2Engine.gradeFlashCard(cardParameter: cardParameter, grade: sm2grade, currentDatetime: SM2LibTests.october_23_2016)

        XCTAssertEqual(newCardParameter.repetition, 1)
        XCTAssertEqual(newCardParameter.interval, 1)
        XCTAssertEqual(newCardParameter.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newCardParameter.previousDate, SM2LibTests.october_23_2016)
        XCTAssertEqual(newCardParameter.nextDate, october_24_2016)
    }

    func testgrade_5_response() {
        let sm2grade = SM2Grade.bright
        let oneDay = 86400.0
        let october_24_2016 = SM2LibTests.october_23_2016 + oneDay
        let expectedEasinessFactor = 2.6
        let cardParameter = SM2LibTests.defaultCardParameter
        let newCardParameter = SM2Engine.gradeFlashCard(cardParameter: cardParameter, grade: sm2grade, currentDatetime: SM2LibTests.october_23_2016)

        XCTAssertEqual(newCardParameter.repetition, 1)
        XCTAssertEqual(newCardParameter.interval, 1)
        XCTAssertEqual(newCardParameter.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newCardParameter.previousDate, SM2LibTests.october_23_2016)
        XCTAssertEqual(newCardParameter.nextDate, october_24_2016)
    }

    func testgrade_5_long_response() {
        let sm2grade = SM2Grade.bright
        let oneDay = 86400.0
        let november_8_2016 = SM2LibTests.october_23_2016 + (oneDay * 16)
        let expectedEasinessFactor = 2.6
        let cardParameter = SM2CardParameter(repetition: 6, interval: 6, easinessFactor: 2.5, previousDate: SM2LibTests.october_23_2016, nextDate: SM2LibTests.october_23_2016)

        let newCardParameter = SM2Engine.gradeFlashCard(cardParameter: cardParameter, grade: sm2grade, currentDatetime: SM2LibTests.october_23_2016)

        XCTAssertEqual(newCardParameter.repetition, 7)
        XCTAssertEqual(newCardParameter.interval, 16)
        XCTAssertEqual(newCardParameter.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newCardParameter.previousDate, SM2LibTests.october_23_2016)
        XCTAssertEqual(newCardParameter.nextDate, november_8_2016)
    }

    func testgrade_6_response() {
        let sm2grade = SM2Grade.pass
        let expectedEasinessFactor = 1.3
        let cardParameter = SM2CardParameter(repetition: 1, interval: 1, easinessFactor: 1.2, previousDate: SM2LibTests.october_23_2016, nextDate: SM2LibTests.october_23_2016)

        let newCardParameter = SM2Engine.gradeFlashCard(cardParameter: cardParameter, grade: sm2grade, currentDatetime: SM2LibTests.october_23_2016)

        XCTAssertEqual(newCardParameter.repetition, 2)
        XCTAssertEqual(newCardParameter.interval, SM2LibTests.defaultInterval)
        XCTAssertEqual(newCardParameter.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newCardParameter.previousDate, SM2LibTests.october_23_2016)
        XCTAssertEqual(newCardParameter.nextDate, SM2LibTests.october_23_2016)
    }

        static var allTests = [
            ("testGradeDescription", testGradeDescription)
        ]
}
