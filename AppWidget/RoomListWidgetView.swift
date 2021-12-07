//
//  RoomListWidgetView.swift
//  AppWidgetExtension
//
//  Created by ernven on 30.11.2021.
//

import SwiftUI
import WidgetKit

@ViewBuilder func setStatusIcon(status: Bool) -> some View {
    
    if !status {
        Image(systemName: "circle.fill")
            .foregroundColor(Color.green)
    } else {
        Image(systemName: "circle.fill")
            .foregroundColor(Color.red)
    }
}

// This view is used with the small and medium size widgets.
struct RoomListWidgetViewMedium: View {
    var rooms: [Room]
    
    // For these views, we can show 6 entries without list going over the view.
    var favoriteRooms: [Room] {
        let starred = rooms.filter { room in
            room.starred
        }
        return Array(starred.prefix(6))
    }
    
    var body: some View {
        VStack {
            ForEach(favoriteRooms) { room in
                HStack {
                    Text("\(room.floor)")
                    Spacer()
                    Text("\(room.roomName)")
                        .frame(width: 90)
                    Spacer()
                    setStatusIcon(status: room.busy)
                }
                .padding(.leading, 10).padding(.trailing, 15)
                .imageScale(.large)
            }
                
            Spacer()
        }
        .padding(20).padding(.top, 10)
    }
}

// This works well with large sized widgets.
struct RoomListWidgetView: View {
    var rooms: [Room]
    
    var favoriteRooms: [Room] {
        let starred = rooms.filter { room in
            room.starred
        }
        return Array(starred.prefix(12))
    }
    
    var body: some View {
        VStack {
            ForEach(favoriteRooms) { room in
                HStack {
                    Text("\(room.floor)")
                    Spacer()
                    Text("\(room.roomName)")
                        .frame(width: 90)
                    Spacer()
                    setStatusIcon(status: room.busy)
                }
                .padding(.leading, 10).padding(.trailing, 15)
                .imageScale(.large)
            }
                
            Spacer()
        }
        .padding(20)
    }
}
