//
//  ContentView.swift
//  PopUpRooms
//
//  Created by ernven on 22.10.2021.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Text("Pop Up Meeting Rooms")
                .font(.title)
                .padding(EdgeInsets(top:20,leading:0,bottom:0,trailing:0))
            RoomList()
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
