//
//  AppWidget.swift
//  AppWidget
//
//  Created by ernven on 30.11.2021.
//

import WidgetKit
import SwiftUI


struct RoomEntry: TimelineEntry {
    let date: Date
    let rooms: [Room]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RoomEntry {
        return RoomEntry(date: Date(), rooms: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (RoomEntry) -> ()) {
        // For snapshots we can use local data to speed up the process. We have the old placeholderData file which can be used.
        let data: Data
        let rooms: [Room]
        
        guard let file = Bundle.main.url(forResource: "placeholderdata.json", withExtension: nil) else {
            fatalError("Couldn't find \("placeholderdata.json") in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \("placeholderdata.json") from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            rooms = try decoder.decode([Room].self, from: data)
        } catch {
            fatalError("Couldn't parse \("placeholderdata.json") as \([Room].self):\n\(error)")
        }
        let entry = RoomEntry(date: Date(), rooms: rooms)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let dataHandler = DataHandler()
        
        dataHandler.loadDataFromAPI() { (parsed, error) in
            if let error = error { print(error) }
            
            if var parsed = parsed {
                // We load the locally saved favorites now.
                dataHandler.loadLocalData() { (favoriteRooms, error) in
                    if let error = error { print(error) }
                    
                    if let favoriteRooms = favoriteRooms {
                        for (index, value) in parsed.enumerated() {
                            if favoriteRooms.contains(value.id) { parsed[index].starred.toggle() }
                        }
                    }
                    
                    var entries: [RoomEntry] = []

                    // Generate a timeline consisting of an entry with the current time.
                    let currentDate = Date()
                    
                    let entry = RoomEntry(date: currentDate, rooms: parsed)
                    entries.append(entry)

                    // When to refresh should depend if the user is likely to be in the office (office hours?).
                    let calendar = Calendar.autoupdatingCurrent
                    
                    // During working hours, create a date that's 5 minutes in the future.
                    var nextUpdateDate = calendar.date(byAdding: .minute, value: 5, to: currentDate)!
                    
                    // If it's the weekend, next update should be Monday 8AM
                    if (calendar.isDateInWeekend(currentDate)
                        || (calendar.component(.weekday, from: currentDate) == 6 && calendar.component(.hour, from: currentDate) > 16))
                    {
                        let nextMonday = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate)!
                        var dateComponents = calendar.dateComponents([.year, .weekOfYear, .weekday, .hour, .minute, .second], from: nextMonday)
                        dateComponents.weekday = 2
                        dateComponents.hour = 8
                        dateComponents.minute = 0
                        dateComponents.second = 0
                        nextUpdateDate = calendar.date(from: dateComponents)!
                        print("ITS TOO LATE TO REFRESH! IT SHOULD HAPPEN ", nextUpdateDate)
                        
                    } else if (calendar.component(.hour, from: currentDate) < 8) {
                        // Is it before 8? If so, update at 8AM.
                        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
                        dateComponents.hour = 8
                        dateComponents.minute = 0
                        dateComponents.second = 0
                        nextUpdateDate = calendar.date(from: dateComponents)!
                        print("ITS TOO EARLY TO REFRESH! IT SHOULD HAPPEN ", nextUpdateDate)
                        
                    } else if (calendar.component(.hour, from: currentDate) > 16) {
                        // After 17, it should update next day at 8AM.
                        let tomorrow = calendar.date(byAdding: .day, value: 1, to: currentDate)!
                        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: tomorrow)
                        dateComponents.hour = 8
                        dateComponents.minute = 0
                        dateComponents.second = 0
                        nextUpdateDate = calendar.date(from: dateComponents)!
                    }
                    
                    // Create the timeline with the entry and a reload policy with the date for the next update.
                    let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
                    
                    completion(timeline)
                }
            }
        }
    }
}

// This contains the SwiftUI View of the widget.
struct AppWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let entry: RoomEntry

    var body: some View {
        // Here comes the view for the widget.
        switch family {
        case .systemSmall: RoomListWidgetViewMedium(rooms: entry.rooms)
        case .systemMedium: RoomListWidgetViewMedium(rooms: entry.rooms)
        case .systemLarge: RoomListWidgetView(rooms: entry.rooms) // Looks good on large, check medium!
        default: RoomListWidgetViewMedium(rooms: entry.rooms)  // .onTapGesture { WidgetCenter.shared.reloadAllTimelines() } Force refresh (for debugging).
        }
    }
}

// This is the entry point for the widget extension.
@main
struct AppWidget: Widget {
    let kind: String = "popup.rooms.list.display"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AppWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("PopUp Rooms list Widget")
        .description("This widget displays a list of available rooms at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

/*
struct RoomListWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
} */
