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
    
    // This variable will store our rooms array (initially it's empty).
    // We need to publish changes, hence the attribute.
    //@Published var rooms: [Room] = loadLocalData("placeholderdata.json")   To be used with local data. For testing, etc.
    @Published var rooms = [Room]()
    
    // This function is called when the UI loads, to populate the array with server data.
    func fetchRooms() {
        loadDataFromAPI() { (parsed, error) in
            if let error = error {
                print(error)
            }
            
            if let parsed = parsed {
                // Publishing values must be done from the main thread (same as UI).
                DispatchQueue.main.async {
                    self.rooms = parsed
                }
            }
        }
    }
}


// These are the URLs of our Back End endpoints (we force-unwrap it, since we will be adding it ourselves).
let apiURL = URL(string: "")!
let sseURL = URL(string: "")!




// This function handles the load of data from our REST API.
func loadDataFromAPI(completionHandler:@escaping ([Room]?, Error?) -> ()) {
    
    URLSession.shared.dataTask(with: apiURL) { data, response, error in
        
        if let error = error {
            completionHandler(nil, error)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
            print(response!)
            return
        }
        
        if let raw = data {
            do {
                let parsed = try JSONDecoder().decode([Room].self, from: raw)  // Should this be in a dispatch?
                completionHandler(parsed, nil)
            } catch {
                fatalError("Couldn't parse \(raw) as \(Room.self)")
            }
        }
    }
    .resume()
}


// This function handles the load of hardcoded data from our local file (used for testing purposes only! Not atm).
func loadLocalData<T: Decodable>(_ filename: String) -> T {
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
