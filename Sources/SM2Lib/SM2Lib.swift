//
//  SM2.swift
//  SM2Lib
//
//  Created by THORBEN ANDRESEN on 5/6/20.
//

import Foundation

public enum SM2Error: Error, LocalizedError {
    case gradeOutOfRange(Int)
    
    public var errorDescription: String? {
        switch self {
        case .gradeOutOfRange(let grade):
            return "Grade \(grade) is out of range"
        }
    }
    
}


/**  Grades from SuperMemo Algorithm
 * 0 - complete blackout.
 * 1 - incorrect response; the correct one remembered
 * 2 - incorrect response; where the correct one seemed easy to recall
 * 3 - correct response recalled with serious difficulty
 * 4 - correct response after a hesitation
 * 5 - perfect response
 */

public enum SM2Grade: Int, CustomStringConvertible, CaseIterable {
    /// complete blackout.
    case null
    /// incorrect response; the correct one remembered
    case bad
    /// incorrect response; where the correct one seemed easy to recall
    case fail
    /// correct response recalled with serious difficulty
    case pass
    /// correct response after a hesitation
    case good
    /// perfect response
    case bright
    
   public var description: String {
        switch self {
        case .null:
            return NSLocalizedString("0 - Complete blackout", comment: "")
        case .bad:
            return NSLocalizedString("1 - Incorrect response; the correct one remembered", comment: "")
        case .fail:
            return NSLocalizedString("2 - Incorrect response; where the correct one seemed easy to recall", comment: "")
        case .pass:
            return NSLocalizedString("3 - Correct response recalled with serious difficulty", comment: "")
        case .good:
            return NSLocalizedString("4 - Correct response after a hesitation", comment: "")
        case .bright:
            return NSLocalizedString("5 - Perfect response", comment: "")
            
        }
    }
}

public protocol SM2GradeDataType {
    var repetition: Int { get }
    var interval: Int { get }
    var easinessFactor: Double { get }
    var previousDate: TimeInterval { get }
    var nextDate: TimeInterval { get }
}

public struct SM2GradeData: SM2GradeDataType {
    public var repetition = 0
    public var interval = 0
    public var easinessFactor = 2.5
    public var previousDate = Date().timeIntervalSince1970
    public var nextDate = Date().timeIntervalSince1970
    
    public init() {}
    
    public init(
        repetition: Int,
        interval: Int,
        easinessFactor: Double,
        previousDate: TimeInterval,
        nextDate: TimeInterval
    ) {
        self.repetition = repetition
        self.interval = interval
        self.easinessFactor = easinessFactor
        self.previousDate = previousDate
        self.nextDate = nextDate
    }
}

public struct SM2Engine {
    
    /// Max Grade `Grade.bright`
    /// The default value is 5
    public static func gradeFlashCard(gradeData: SM2GradeDataType, grade: SM2Grade, currentDatetime: TimeInterval, maxGrade: Int = 5) -> SM2GradeDataType {
        
        let cardGrade = grade.rawValue
        
        // The default value is 1.3
        var easinessFactor = 1.3
        var repetition: Int
        var interval: Int
        var previousDate: TimeInterval
        var nextDate: TimeInterval

        if cardGrade < 3 {
            repetition = 0
            interval = 0
        } else {
            let qualityFactor = Double(maxGrade - cardGrade) // CardGrade.bright.rawValue - grade
            
            // Easiness Factor
            let newEasinessFactor = gradeData.easinessFactor + (0.1 - qualityFactor * (0.08 + qualityFactor * 0.02))
            if newEasinessFactor < easinessFactor {
                easinessFactor = gradeData.easinessFactor
            } else {
                easinessFactor = newEasinessFactor
            }
            
            // Repetition
            repetition = gradeData.repetition + 1
            
            // Interval
            switch repetition {
            case 1:
                interval = 1
            case 2:
                interval = 6
            default:
                let newInterval = ceil(Double(repetition - 1) * easinessFactor)
                interval = Int(newInterval)
            }
        }
        
        if cardGrade == 3 {
            interval = 0
        }
        
        let seconds = 60
        let minutes = 60
        let hours = 24
        let dayMultiplier = seconds * minutes * hours // 1
        let extraDays = dayMultiplier * interval
        let newNextDatetime = currentDatetime + Double(extraDays)
        previousDate = gradeData.nextDate
        nextDate = newNextDatetime
        
        let gradeData = SM2GradeData(
            repetition: repetition,
            interval: interval,
            easinessFactor: easinessFactor,
            previousDate: previousDate,
            nextDate: nextDate
        )
        
        return gradeData
    }
}

//  1 - Time intervals are used instead of calender calculations because the algorithm does not care about dates.



