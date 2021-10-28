//
//  Header.swift
//  PopUpRooms
//
//  Created by ernven on 28.10.2021.
//

import SwiftUI

struct Header: View {
    var body: some View {
        ZStack(alignment: .leading) {
            // Color expects 3 Doubles from 0.0 to 1.0, hence why written like that.
            Color(red: 20/255, green: 138/255, blue: 179/255)
                .ignoresSafeArea()
            
            Image("headerPic")
                .resizable()
                .scaledToFill()
                //.aspectRatio(contentMode: .fill)  This does the same thing.
                //.padding(.top, 50)
            
            Text("Pop Up Meeting Rooms")
                .font(.title)
                .padding(.top, 20).padding(.leading, 15)
        }
        .frame(height: 80.0)
        .foregroundColor(.white)
    }
}
