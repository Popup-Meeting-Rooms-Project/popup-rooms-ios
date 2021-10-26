//
//  RoomRow.swift
//  PopUpRooms
//
//  Created by ernven on 24.10.2021.
//

import SwiftUI

@ViewBuilder func setStatusIcon(status: Bool) -> some View {
    if status {
        Image(systemName: "circle.fill")
            .foregroundColor(Color.green)
    } else {
        Image(systemName: "circle.fill")
            .foregroundColor(Color.red)
    }
}

struct RoomRow: View {
    var room: Room
    
    var body: some View {
        HStack {
            Text("\(room.roomNo)")
            Spacer()
            Text("\(room.floor)")
            Spacer()
            setStatusIcon(status: room.status)
            Spacer()
            if room.starred {
                Image(systemName: "star.fill")
                    .foregroundColor(Color.yellow)
            } else {
                Image(systemName: "star")
                    .foregroundColor(.secondary)
                
            }
        }
        .imageScale(.large)
    }
}
