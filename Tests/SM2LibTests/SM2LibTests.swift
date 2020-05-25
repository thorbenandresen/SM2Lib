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
    
    func testGradeData() {
        
        let actual = SM2GradeData()
        XCTAssertEqual(actual.repetition, 0)
        XCTAssertEqual(actual.interval, 0)
        XCTAssertEqual(actual.easinessFactor, 2.5)
        
    }
    
    
    func testgrade_0_response() {
        let sm2grade = SM2Grade.null
        let october_23_2016 = 1477207892.0
        let expectedEasinessFactor = 2.5
        let gradeData = SM2GradeData()
        
        let newGradeData = SM2Engine.gradeFlashCard(gradeData: gradeData, grade: sm2grade, currentDatetime: october_23_2016)
        
        XCTAssertEqual(newGradeData.repetition, 0)
        XCTAssertEqual(newGradeData.interval, 0)
        XCTAssertEqual(newGradeData.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newGradeData.previousDate, nil)
        XCTAssertEqual(newGradeData.nextDate, october_23_2016)
    }
    
    
    func testgrade_1_response() {
        let sm2grade = SM2Grade.bad
        let october_23_2016 = 1477207892.0
        let expectedEasinessFactor = 2.5
        let gradeData = SM2GradeData()
        
        let newGradeData = SM2Engine.gradeFlashCard(gradeData: gradeData, grade: sm2grade, currentDatetime: october_23_2016)
        
        XCTAssertEqual(newGradeData.repetition, 0)
        XCTAssertEqual(newGradeData.interval, 0)
        XCTAssertEqual(newGradeData.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newGradeData.previousDate, nil)
        XCTAssertEqual(newGradeData.nextDate, october_23_2016)
    }
    
    func testgrade_2_response() {
        let sm2grade = SM2Grade.bad
        let october_23_2016 = 1477207892.0
        let expectedEasinessFactor = 2.5
        let gradeData = SM2GradeData()
        
        let newGradeData = SM2Engine.gradeFlashCard(gradeData: gradeData, grade: sm2grade, currentDatetime: october_23_2016)
        
        XCTAssertEqual(newGradeData.repetition, 0)
        XCTAssertEqual(newGradeData.interval, 0)
        XCTAssertEqual(newGradeData.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newGradeData.previousDate, nil)
        XCTAssertEqual(newGradeData.nextDate, october_23_2016)
    }
    
    func testgrade_3_response() {
        let sm2grade = SM2Grade.pass
        let october_23_2016 = 1477207892.0
        let expectedEasinessFactor = 2.36
        let gradeData = SM2GradeData()
        
        let newGradeData = SM2Engine.gradeFlashCard(gradeData: gradeData, grade: sm2grade, currentDatetime: october_23_2016)
        
        XCTAssertEqual(newGradeData.repetition, 1)
        XCTAssertEqual(newGradeData.interval, 0)
        XCTAssertEqual(newGradeData.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newGradeData.previousDate, nil)
        XCTAssertEqual(newGradeData.nextDate, october_23_2016)
    }
    
    func testgrade_4_response() {
        let sm2grade = SM2Grade.good
        let october_23_2016 = 1477207892.0
        let oneDay = 86400.0
        let october_24_2016 = october_23_2016 + oneDay
        let expectedEasinessFactor = 2.5
        let gradeData = SM2GradeData()
        let newGradeData = SM2Engine.gradeFlashCard(gradeData: gradeData, grade: sm2grade, currentDatetime: october_23_2016)
        
        XCTAssertEqual(newGradeData.repetition, 1)
        XCTAssertEqual(newGradeData.interval, 1)
        XCTAssertEqual(newGradeData.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newGradeData.previousDate, nil)
        XCTAssertEqual(newGradeData.nextDate, october_24_2016)
    }
    
    
    func testgrade_5_response() {
        let sm2grade = SM2Grade.bright
        let october_23_2016 = 1477207892.0
        let oneDay = 86400.0
        let october_24_2016 = october_23_2016 + oneDay
        let expectedEasinessFactor = 2.6
        let gradeData = SM2GradeData()
        let newGradeData = SM2Engine.gradeFlashCard(gradeData: gradeData, grade: sm2grade, currentDatetime: october_23_2016)
        
        XCTAssertEqual(newGradeData.repetition, 1)
        XCTAssertEqual(newGradeData.interval, 1)
        XCTAssertEqual(newGradeData.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newGradeData.previousDate, nil)
        XCTAssertEqual(newGradeData.nextDate, october_24_2016)
    }
    
    
    func testgrade_5_long_response() {
        let sm2grade = SM2Grade.bright
        let october_23_2016 = 1477207892.0
        let oneDay = 86400.0
        let november_8_2016 = october_23_2016 + (oneDay * 16)
        let expectedEasinessFactor = 2.6
        let gradeData = SM2GradeData(repetition: 6, interval: 6, easinessFactor: 2.5, previousDate: october_23_2016, nextDate: october_23_2016)
        
        let newGradeData = SM2Engine.gradeFlashCard(gradeData: gradeData, grade: sm2grade, currentDatetime: october_23_2016)
        
        XCTAssertEqual(newGradeData.repetition, 7)
        XCTAssertEqual(newGradeData.interval, 16)
        XCTAssertEqual(newGradeData.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newGradeData.previousDate, october_23_2016)
        XCTAssertEqual(newGradeData.nextDate, november_8_2016)
    }
    
    func testgrade_6_response() {
        let sm2grade = SM2Grade.pass
        let october_23_2016 = 1477207892.0
        
        let expectedEasinessFactor = 1.3
        let gradeData = SM2GradeData(repetition: 1, interval: 1, easinessFactor: 1.2, previousDate: october_23_2016, nextDate: october_23_2016)
        
        let newGradeData = SM2Engine.gradeFlashCard(gradeData: gradeData, grade: sm2grade, currentDatetime: october_23_2016)
        
        XCTAssertEqual(newGradeData.repetition, 2)
        XCTAssertEqual(newGradeData.interval, 0)
        XCTAssertEqual(newGradeData.easinessFactor, expectedEasinessFactor)
        XCTAssertEqual(newGradeData.previousDate, october_23_2016)
        XCTAssertEqual(newGradeData.nextDate, october_23_2016)
    }
        
        
        
        
        
        static var allTests = [
            ("testGradeDescription", testGradeDescription),
        ]
}
