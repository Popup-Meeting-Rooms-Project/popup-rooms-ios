//
//  StarButton.swift
//  PopUpRooms
//
//  Created by ernven on 27.10.2021.
//

import SwiftUI

struct StarButton: View {
    // We use a binding so that changes made in this view flow back to the data source.
    @Binding var isSet: Bool
    
    var body: some View {
        Button(action: {
            isSet.toggle()
            
        }) {
            // For the icon, we render conditionally either a filled yellow star (fav'd) or the gray outline of one.
            // In Swift we can also use ternary operators for if-else.
            Image(systemName: isSet ? "star.fill" : "star")
                .foregroundColor(isSet ? Color.yellow : .secondary)
        }
        
    }
}
