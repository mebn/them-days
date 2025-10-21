//
//  timeDifference.swift
//  themDays
//
//  Created by Marcus Nilszén on 2025-10-21.
//
import Foundation

enum TimeDifference {
    private static func formattedInterval(_ interval: TimeInterval,
                                          allowedUnits: NSCalendar.Unit,
                                          maximumUnitCount: Int) -> String?
    {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = allowedUnits
        formatter.maximumUnitCount = maximumUnitCount
        formatter.unitsStyle = .short
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        return formatter.string(from: interval)?.replacingOccurrences(of: ", ", with: " and ")
    }

    static func homeRelativeString(for date: Date, referenceDate: Date) -> String {
        let interval = date.timeIntervalSince(referenceDate)
        let absoluteInterval = abs(interval)

        guard absoluteInterval >= 1,
              let formatted = formattedInterval(absoluteInterval,
                                                allowedUnits: [.year, .month, .day, .hour, .minute, .second],
                                                maximumUnitCount: 2)
        else {
            return "just now"
        }

        if interval >= 0 {
            return "in \(formatted)"
        } else {
            return "\(formatted) ago"
        }
    }

    static func widgetRelativeString(for date: Date, referenceDate: Date) -> String {
        let interval = date.timeIntervalSince(referenceDate)
        let absoluteInterval = abs(interval)
        let hour: TimeInterval = 3600

        if absoluteInterval < hour {
            if interval >= 0 {
                return "in less than 1 hour"
            } else {
                return "less than 1 hour ago"
            }
        }

        if let formatted = formattedInterval(absoluteInterval,
                                             allowedUnits: [.year, .month, .day, .hour],
                                             maximumUnitCount: 2)
        {
            if interval >= 0 {
                return "in \(formatted)"
            } else {
                return "\(formatted) ago"
            }
        }

        let hours = Int(absoluteInterval / hour)
        if interval >= 0 {
            return "in \(hours) hours"
        } else {
            return "\(hours) hours ago"
        }
    }
}
