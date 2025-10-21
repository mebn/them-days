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
    @State private var sheetMode: SheetMode?
    @Query(sort: \CounterItem.date, order: .forward) private var counterItems: [CounterItem]
    @State private var now = Date()
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
                            Text(TimeDifference.homeRelativeString(for: item.date, referenceDate: now))
                        }
                        .onTapGesture {
                            sheetMode = .edit(item)
                        }
                    }
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        sheetMode = .new
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            now = Date()
        }
        .sheet(item: $sheetMode) { mode in
            switch mode {
            case .new:
                CounterView()
                    .interactiveDismissDisabled(true)
            case let .edit(counter):
                CounterView(counter: counter)
                    .interactiveDismissDisabled(true)
            }
        }
    }
}

#Preview {
    HomeView()
}

private enum SheetMode: Identifiable {
    case new
    case edit(CounterItem)

    var id: String {
        switch self {
        case .new:
            return "new"
        case let .edit(counter):
            return counter.id
        }
    }
}
