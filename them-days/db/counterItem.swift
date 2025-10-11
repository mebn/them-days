//
//  db.swift
//  them-days
//
//  Created by Marcus Nilszén on 2025-10-09.
//

import Foundation
import SwiftData

@Model
final class CounterItem {
    var id: String
    var title: String
    var date: Date
    
    init(title: String, date: Date) {
        self.id = UUID().uuidString
        self.title = title
        self.date = date
    }
}
