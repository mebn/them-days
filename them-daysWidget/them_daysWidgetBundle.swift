//
//  them_daysWidgetBundle.swift
//  them-daysWidget
//
//  Created by Marcus Nilszén on 2025-10-14.
//

import SwiftUI
import WidgetKit

@main
struct them_daysWidgetBundle: WidgetBundle {
    var body: some Widget {
        them_daysWidget()
        them_daysWidgetControl()
        them_daysWidgetLiveActivity()
    }
}
