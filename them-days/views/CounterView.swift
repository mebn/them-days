//
//  CounterView.swift
//  them-days
//
//  Created by Marcus Nilszén on 2025-10-09.
//

import SwiftUI
import SwiftData

struct CounterView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    private let counter: CounterItem?

    @State private var title: String
    @State private var counterDate: Date

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var isEditing: Bool {
        counter != nil
    }

    init(counter: CounterItem? = nil) {
        self.counter = counter
        _title = State(initialValue: counter?.title ?? "")
        _counterDate = State(initialValue: counter?.date ?? Date())
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                
                HStack {
                    DatePicker("Date", selection: $counterDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    
                    DatePicker("", selection: $counterDate, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }

                if isEditing {
                    Section {
                        Button("Reset") {
                            resetFields()
                        }

                        Button("Delete", role: .destructive) {
                            deleteCounter()
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Counter" : "New Counter")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isEditing ? "Save" : "Add") {
                        saveCounter()
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    private func saveCounter() {
        guard canSave else { return }

        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if let counter {
            counter.title = trimmedTitle
            counter.date = counterDate
        } else {
            let newItem = CounterItem(title: trimmedTitle, date: counterDate)
            modelContext.insert(newItem)
        }

        try? modelContext.save()
    }

    private func resetFields() {
        guard let counter else { return }

        counterDate = Date()
        counter.date = counterDate
        try? modelContext.save()
        dismiss()
    }

    private func deleteCounter() {
        guard let counter else { return }

        modelContext.delete(counter)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: CounterItem.self, inMemory: true)
}
