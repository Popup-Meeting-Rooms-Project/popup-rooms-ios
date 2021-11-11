//
//  RoomData.swift
//  PopUpRooms
//
//  Created by ernven on 23.10.2021.
//

import Foundation
import Combine

// These are the URLs of our Back End endpoints (we force-unwrap it, since we will be adding it ourselves).
private let apiURL = URL(string: "")!
private let sseURL = URL(string: "")!

// This function returns the URL of a file "favoriteRooms.data" from the user's Documents folder.
func getFileURL() -> URL {
    guard let documentsFolder: URL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { fatalError("Can't find documents directory.") }
    return documentsFolder.appendingPathComponent("favoriteRooms.data")
}


// In order to allow the user to control certain properties (e.g. adding favorites), our data needs to be stored in an observable object.
// (Meaning our class needs to adopt this protocol)
final class RoomData: ObservableObject {
    
    // This variable will store our rooms array (initially it's empty).
    // We need to publish changes, hence the attribute.
    //@Published var rooms: [Room] = loadExternalFileData("placeholderdata.json")   To be used with local data. For testing, etc.
    @Published var rooms = [Room]()
    
    // This function is called when the UI loads, to populate the array with server data.
    func load() {
        loadDataFromAPI() { (parsed, error) in
            if let error = error { print(error) }
            
            if let parsed = parsed {
                // Publishing values must be done from the main thread (same as UI).
                DispatchQueue.main.async {
                    self.rooms = parsed
                    
                    // We load the local data now, to ensure the right order of loading. (TEST!!)
                    loadLocalData() { (favoriteRooms, error) in
                        if let error = error { print(error) }
                        
                        if let favoriteRooms = favoriteRooms {
                            DispatchQueue.main.async {
                                for (index, value) in self.rooms.enumerated() {
                                    if favoriteRooms.contains(value.id) { self.rooms[index].starred.toggle() }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func saveFavorites() {
        DispatchQueue.global(qos: .background).async {
            // We save favorites if any exists
            if self.rooms.contains(where: { $0.starred }) {
                
                // We create a Set with the Ids of favorited rooms.
                let favoriteIds = Set(self.rooms.compactMap({ $0.starred ? $0.id : nil }))
                
                // Then we encode our data to be saved with JSONEncoder.
                guard let data = try? JSONEncoder().encode(favoriteIds) else { fatalError("Error encoding data") }
                
                do {
                    let outfile = getFileURL()
                    try data.write(to: outfile)
                } catch { fatalError("Can't write to file") }
            }
        }
    }
}


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
                fatalError("Couldn't parse \(raw) as \(RoomData.self).")
            }
        }
    }
    .resume()
}


// This function handles the load of Favorites saved to the App's Documents folder.
func loadLocalData(completionHandler:@escaping (Set<Int>?, Error?) -> ()) {
    
    DispatchQueue.global(qos: .background).async {
        let fileURL = getFileURL()
        
        guard let data = try? Data(contentsOf: fileURL) else { return }
        
        guard let favoriteRooms = try? JSONDecoder().decode(Set<Int>.self, from: data) else {
            fatalError("Can't decode saved room favorites data.")
        }
        
        completionHandler(favoriteRooms, nil)
    }
}


// This function handles the load of hardcoded data from our local file (used for testing purposes only! Not atm).
func loadExternalFileData<T: Decodable>(_ filename: String) -> T {
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
