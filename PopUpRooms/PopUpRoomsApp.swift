//
//  PopUpRoomsApp.swift
//  PopUpRooms
//
//  Created by ernven on 22.10.2021.
//

import SwiftUI

@main
struct PopUpRoomsApp: App {
    @StateObject private var roomData = RoomData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(roomData)
        }
    }
}
