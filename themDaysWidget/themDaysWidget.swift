//
//  themDaysWidget.swift
//  themDaysWidget
//
//  Created by Marcus Nilszén on 2025-10-14.
//

import SwiftData
import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    func placeholder(in _: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: .init())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in _: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in _: Context) async -> Timeline<SimpleEntry> {
        let now = Date()
        guard let counter = configuration.counterItem else {
            let entry = SimpleEntry(date: now, configuration: configuration)
            let reloadDate = Calendar.current.date(byAdding: .hour, value: 1, to: now) ?? now.addingTimeInterval(3600)
            return Timeline(entries: [entry], policy: .after(reloadDate))
        }

        var entries: [SimpleEntry] = []
        var currentDate = now
        let horizon = now.addingTimeInterval(48 * 3600)

        for _ in 0 ..< 48 {
            entries.append(SimpleEntry(date: currentDate, configuration: configuration))

            guard let nextDate = nextUpdateDate(after: currentDate, counterDate: counter.counterDate) else {
                break
            }

            if nextDate > horizon {
                break
            }

            currentDate = nextDate
        }

        if entries.isEmpty {
            entries.append(SimpleEntry(date: now, configuration: configuration))
        }

        let reloadDate = entries.last?.date.addingTimeInterval(3600) ?? now.addingTimeInterval(3600)
        return Timeline(entries: entries, policy: .after(reloadDate))
    }

    private func nextUpdateDate(after date: Date, counterDate: Date) -> Date? {
        let interval = date.timeIntervalSince(counterDate)
        let hour: TimeInterval = 3600
        let absolute = abs(interval)

        let remainder = absolute.truncatingRemainder(dividingBy: hour)

        let secondsUntilBoundary: TimeInterval
        if interval >= 0 {
            secondsUntilBoundary = remainder == 0 ? hour : hour - remainder
        } else {
            secondsUntilBoundary = remainder == 0 ? hour : remainder
        }

        let nextInterval = max(1, min(secondsUntilBoundary, hour))
        return date.addingTimeInterval(nextInterval)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct themDaysWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        if let counter = entry.configuration.counterItem {
            VStack {
                Text(counter.counterTitle)
                Text(TimeDifference.widgetRelativeString(for: counter.counterDate, referenceDate: entry.date))
            }
        } else {
            Text("Add a new counter in the app")
        }
    }
}

struct themDaysWidget: Widget {
    let kind: String = "themDaysWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            themDaysWidgetEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
    }
}

private extension ConfigurationAppIntent {
    static var item: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.counterItem = CounterItemEntity(
            id: "test",
            counterTitle: "A title!",
            counterDate: Date().addingTimeInterval(-90 * 24 * 3600)
        )
        return intent
    }

    static var noItem: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        return intent
    }
}

#Preview(as: .systemSmall) {
    themDaysWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .item)
    SimpleEntry(date: .now, configuration: .noItem)
}
