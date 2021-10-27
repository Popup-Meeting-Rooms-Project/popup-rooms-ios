//
//  RoomList.swift
//  PopUpRooms
//
//  Created by ernven on 25.10.2021.
//

import SwiftUI

struct RoomList: View {
    // To subscribe to changes, room data is added as an Environment Object.
    @EnvironmentObject var roomData: RoomData
    
    @State private var showFavsOnly = false
    @State private var showAvailableOnly = false
    @State private var isSorted = false
    
    
    // This function will handle the sorting and filtering of the rows to be displayed.
    var filteredRooms: [Room] {
        var rooms = roomData.rooms
        
        if (!isSorted) {
            rooms.sort { $0.roomNo < $1.roomNo }
            isSorted = true
        }
        
        if (showFavsOnly) {
            return rooms.filter {room in
                room.starred && (!showAvailableOnly || room.status)
          }
        } else if (showAvailableOnly) {
            return rooms.filter { room in
                room.status && (!showFavsOnly || room.starred)
            }
        } else {
            return rooms
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showFavsOnly) {
                    Text("Show Favorites only")
                }
                Toggle(isOn: $showAvailableOnly) {
                    Text("Show Available only")
                }
                
                //RoomRow(room: Room(id:"a3",roomNo:101,floor:1,status:true))   USED FOR DEBUGGING
                ForEach(filteredRooms) { room in
                    RoomRow(room: room)
                        .padding()
                }
            }
            // This adds an animation for the expanding/collapsing of the list.
            //.animation(.spring())
            .navigationTitle("Main Office")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 8"], id: \.self) { deviceName in

            ContentView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .environmentObject(RoomData())
        }
        
    }
}

