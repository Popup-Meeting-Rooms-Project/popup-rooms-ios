//
//  RoomData.swift
//  PopUpRooms
//
//  Created by ernven on 23.10.2021.
//

import Foundation
import Combine

// In order to allow the user to control certain properties (e.g. adding favorites), our data needs to be stored in an observable object.
// (Meaning our class needs to adopt this protocol)
final class RoomData: ObservableObject {
    
    // We load the initial data for the rooms into a variable.
    // We need to publish changes, hence the attribute.
    @Published var rooms: [Room] = load("placeholderdata.json")
    
}



// This function handles the load of hardcoded data from our local file.
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
