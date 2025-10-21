//
//  AppIntent.swift
//  themDaysWidget
//
//  Created by Marcus Nilszén on 2025-10-14.
//

import AppIntents
import SwiftData
import WidgetKit

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Them Days" }
    static var description: IntentDescription { "Select a counter to show in the widget." }

    @Parameter(title: "Counter")
    var counterItem: CounterItemEntity?
}

struct CounterItemEntity: AppEntity {
    var id: String
    var counterTitle: String
    var counterDate: Date

    init(model: CounterItem) {
        id = model.id
        counterTitle = model.title
        counterDate = model.date
    }

    init(id: String, counterTitle: String, counterDate: Date) {
        self.id = id
        self.counterTitle = counterTitle
        self.counterDate = counterDate
    }

    static var defaultQuery = CounterItemQuery()

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Widget counter"
    }

    var displayRepresentation: DisplayRepresentation {
        let subtitle = counterDate.formatted(date: .abbreviated, time: .shortened)
        return DisplayRepresentation(title: "\(counterTitle)", subtitle: "\(subtitle)")
    }
}

struct CounterItemQuery: EntityQuery {
    private func makeContainer() throws -> ModelContainer {
        let schema = Schema([CounterItem.self])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            groupContainer: .identifier("group.com.anon.themDays")
        )

        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }

    func entities(for identifiers: [CounterItemEntity.ID]) async throws -> [CounterItemEntity] {
        let container = try makeContainer()
        let context = ModelContext(container)
        let fetch = FetchDescriptor<CounterItem>()
        let results = try context.fetch(fetch)
        return results
            .filter { identifiers.contains($0.id) }
            .map { CounterItemEntity(model: $0) }
    }

    func suggestedEntities() async throws -> [CounterItemEntity] {
        let container = try makeContainer()
        let context = ModelContext(container)
        let fetch = FetchDescriptor<CounterItem>()
        let results = try context.fetch(fetch)
        return results.map { CounterItemEntity(model: $0) }
    }

    func defaultResult() async -> CounterItemEntity? {
        do {
            let container = try makeContainer()
            let context = ModelContext(container)
            let fetch = FetchDescriptor<CounterItem>()
            if let first = try context.fetch(fetch).first {
                return CounterItemEntity(model: first)
            }
        } catch {
            print("SwiftData fetch failed: \(error)")
        }
        return nil
    }
}
