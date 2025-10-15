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
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in _: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in _: Context) async -> Timeline<SimpleEntry> {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        return Timeline(entries: [entry], policy: .never)
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
                Text("Title:")
                Text(counter.counterTitle)

                Text("Date:")
                Text(counter.counterDate)
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
            counterDate: "24 min ago"
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
