//
//  SM2.swift
//  SM2Lib
//
//  Created by THORBEN ANDRESEN on 5/6/20.
//

import Foundation

public enum SM2Error: Error, LocalizedError {
    /// Grade is not valid valid
    case invalidGrade(Int)
    
    public var errorDescription: String? {
        switch self {
        case .invalidGrade(let grade):
            return "Grade \(grade) is not valid"
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
            return NSLocalizedString("complete blackout", comment: "")
        case .bad:
            return NSLocalizedString("incorrect response; the correct one remembered", comment: "")
        case .fail:
            return NSLocalizedString("incorrect response; where the correct one seemed easy to recall", comment: "")
        case .pass:
            return NSLocalizedString("correct response recalled with serious difficulty", comment: "")
        case .good:
            return NSLocalizedString("correct response after a hesitation", comment: "")
        case .bright:
            return NSLocalizedString("perfect response", comment: "")
            
        }
    }
}

/// A type which describes the properties required to calculate the SM2 parameter
public protocol SM2CardParameterType {
    var repetition: Int { get }
    var interval: Int { get }
    var easinessFactor: Double { get }
    var previousDate: TimeInterval { get }
    var nextDate: TimeInterval { get }
}

/// Struct holding the SM2 parameter for a card
public struct SM2CardParameter: SM2CardParameterType {
    public var repetition: Int
    public var interval: Int
    public var easinessFactor: Double
    public var previousDate: TimeInterval
    public var nextDate: TimeInterval
    
    /// Description
    /// - Parameters:
    ///   - repetition: card repetitions
    ///   - interval: interval in days until next due date
    ///   - easinessFactor: easiness factor reflecting the easiness of memorizing and retaining a given item in memory
    ///   - previousDate: previous due date
    ///   - nextDate: next due date
    public init(
        repetition: Int = 0,
        interval: Int = 0,
        easinessFactor: Double = 2.5,
        previousDate: TimeInterval? = nil,
        nextDate: TimeInterval? = nil
    ) {
        
        let currentDate = Date().timeIntervalSince1970
        
        self.repetition = repetition
        self.interval = interval
        self.easinessFactor = easinessFactor
        
        if
            let previousDate = previousDate,
            let nextDate = nextDate {
            
            self.previousDate = previousDate
            self.nextDate = nextDate
            
        } else {
            self.previousDate = currentDate
            self.nextDate = currentDate
        }
        
    }
}

/// Namespaceing the SM2Engine bfor better readability
public struct SM2Engine {
    
    /// Updates SM2CardParameter based on SM2Grade
    /// - Parameters:
    ///   - cardParameter: SM2CardParameter
    ///   - grade: Grade
    ///   - currentDatetime: current time
    ///   - maxGrade: max grade possible
    /// - Returns: a new SM2CardParameter instance with the updated parameter
    public static func gradeFlashCard(cardParameter: SM2CardParameterType, grade: SM2Grade, currentDatetime: TimeInterval, maxGrade: Int = 5) -> SM2CardParameterType {
        
        let rawGrade = grade.rawValue
        
        let easinessFactor = calculateEasinessFactor(grade: rawGrade, maxGrade: maxGrade, previousEasinessFactor: cardParameter.easinessFactor)
        let repetition = calculateRepetition(grade: rawGrade, previousRepetition: cardParameter.repetition)
        let interval = calculateIntervalInDays(grade: rawGrade, repetition: repetition, easinessFactor: easinessFactor)
        let previousDate = cardParameter.nextDate
        let nextDate = addTimeIntervalToDate(intervalInDays: interval, timeInterval: currentDatetime)
  
        let gradeData = SM2CardParameter(
            repetition: repetition,
            interval: interval,
            easinessFactor: easinessFactor,
            previousDate: previousDate,
            nextDate: nextDate
        )
        
        return gradeData
    }
    
    
    private static func calculateRepetition(grade: Int, previousRepetition: Int) -> Int {
        
        if grade < 3 {
            return 0
        }
        
        return previousRepetition + 1
    }
 
    
    private static func calculateEasinessFactor(grade: Int, maxGrade: Int, previousEasinessFactor: Double) -> Double {
        
        if grade < 3 {
           return previousEasinessFactor
        }
        
        var easinessFactor = 1.3
        let qualityFactor = Double(maxGrade - grade)
        let newEasinessFactor = previousEasinessFactor + (0.1 - qualityFactor * (0.08 + qualityFactor * 0.02))
        
        if newEasinessFactor > easinessFactor {
            easinessFactor = newEasinessFactor
        }
        
        return easinessFactor
    }
    
    private static func calculateIntervalInDays(grade: Int ,repetition: Int, easinessFactor: Double) -> Int {
        
        if grade <= 3 {
            return 0
        }
        
        var interval: Int
        switch repetition {
        case 1:
            interval = 1
        case 2:
            interval = 6
        default:
            let newInterval = ceil(Double(repetition - 1) * easinessFactor)
            interval = Int(newInterval)
        }
        return interval
        
    }
    /// Adds a time interval in days to a date
    /// Time intervals are used instead of calender calculations because the algorithm does not care about dates.
    private static func addTimeIntervalToDate(intervalInDays: Int, timeInterval: TimeInterval) -> TimeInterval {
        let seconds = 60
        let minutes = 60
        let hours = 24
        let dayMultiplier = seconds * minutes * hours // 1
        let extraDays = dayMultiplier * intervalInDays
        return timeInterval + Double(extraDays)
        
    }
}


