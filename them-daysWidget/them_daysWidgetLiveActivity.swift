//
//  them_daysWidgetLiveActivity.swift
//  them-daysWidget
//
//  Created by Marcus Nilszén on 2025-10-14.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct them_daysWidgetAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct them_daysWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: them_daysWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

private extension them_daysWidgetAttributes {
    static var preview: them_daysWidgetAttributes {
        them_daysWidgetAttributes(name: "World")
    }
}

private extension them_daysWidgetAttributes.ContentState {
    static var smiley: them_daysWidgetAttributes.ContentState {
        them_daysWidgetAttributes.ContentState(emoji: "😀")
    }

    static var starEyes: them_daysWidgetAttributes.ContentState {
        them_daysWidgetAttributes.ContentState(emoji: "🤩")
    }
}

#Preview("Notification", as: .content, using: them_daysWidgetAttributes.preview) {
    them_daysWidgetLiveActivity()
} contentStates: {
    them_daysWidgetAttributes.ContentState.smiley
    them_daysWidgetAttributes.ContentState.starEyes
}
