//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by WingCH on 15/9/2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct WidgetExtensionEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        
        GeometryReader { metrics in
            VStack(spacing: 0) {
                /*
                 bg1: 17.3mb (6000 × 4000)
                 bg1-min: 89kb (6000 × 4000)
                 bg1-min-cropped: 11kb (320 × 213)
                 */
                Image("bg1-min-cropped")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: metrics.size.height * 0.5)
                    .clipped()
                
                /*
                 bg2: 19.7mb (6000 × 4000)
                 bg2-min: 96kb (6000 × 4000)
                 bg2-min-cropped: 12kb (320 × 213)
                 */
                Image("bg2-min-cropped")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: metrics.size.height * 0.5)
                    .clipped()
                
            }
        }
        
    }
}

@main
struct WidgetExtension: Widget {
    let kind: String = "WidgetExtension"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        WidgetExtensionEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
