//
//  RoomList.swift
//  PopUpRooms
//
//  Created by ernven on 25.10.2021.
//

import SwiftUI

struct ListHeader: View {
    var body: some View {
        HStack {
            Text("Room")
            Spacer()
            Text("Floor")
            Spacer()
            Text("Status")
            Spacer()
            Text("Favorite")
        }
        .font(.headline)
    }
}

struct RoomList: View {
    // To subscribe to changes, room data is added as an Environment Object.
    @EnvironmentObject var roomData: RoomData
    
    @State private var showFavsOnly = false
    @State private var showAvailableOnly = false
    
    
    // This function will handle the sorting and filtering of the rows to be displayed.
    var filteredRooms: [Room] {
        let rooms = roomData.rooms
        
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
                
                Section {
                    //RoomRow(room: Room(id:"a3",roomNo:101,floor:1,status:true))   USED FOR DEBUGGING
                    ForEach(filteredRooms) { room in
                        RoomRow(room: room)
                    }
                } header: {
                    ListHeader()
                }
            }
            .padding(.top, 20).padding(.bottom, 20)
            // We change the style of the list to fit better our sketches.
            .listStyle(.inset)
            
            // This adds an animation for the expanding/collapsing of the list.
            .animation(.spring())
            
            // Here we set the title (and styling).
            .navigationTitle("Main Office")
            //.navigationBarTitle("", displayMode: .inline)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 12"], id: \.self) { deviceName in

            ContentView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .environmentObject(RoomData())        }
        
    }
}
