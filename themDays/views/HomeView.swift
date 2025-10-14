//
//  HomeView.swift
//  them-days
//
//  Created by Marcus Nilszén on 2025-10-09.
//

import Combine
import SwiftData
import SwiftUI

struct HomeView: View {
    @State private var showingSheet = false
    @State private var activeCounter: CounterItem?
    @Query(sort: \CounterItem.date, order: .forward) private var counterItems: [CounterItem]
    @State private var now = Date()
    private let componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.maximumUnitCount = 2
        formatter.unitsStyle = .short
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        return formatter
    }()

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            Group {
                if counterItems.isEmpty {
                    Text("Tap **Add** to create your first counter")
                } else {
                    List(counterItems) { item in
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.title3)
                                .bold()
                            Text(relativeTimeString(for: item.date))
                        }
                        .onTapGesture {
                            activeCounter = item
                            showingSheet = true
                        }
                    }
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        activeCounter = nil
                        showingSheet = true
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            now = Date()
        }
        .sheet(isPresented: $showingSheet, onDismiss: { activeCounter = nil }) {
            CounterView(counter: activeCounter)
                .interactiveDismissDisabled(true)
        }
    }

    private func relativeTimeString(for date: Date) -> String {
        let interval = date.timeIntervalSince(now)
        let absoluteInterval = abs(interval)

        guard absoluteInterval >= 1,
              let formatted = componentsFormatter.string(from: absoluteInterval)
        else {
            return "just now"
        }

        let joined = formatted.replacingOccurrences(of: ", ", with: " and ")
        if interval >= 0 {
            return "in \(joined)"
        } else {
            return "\(joined) ago"
        }
    }
}

#Preview {
    HomeView()
}
