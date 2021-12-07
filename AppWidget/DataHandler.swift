//
//  NetworkClient.swift
//  AppWidgetExtension
//
//  Created by ernven on 1.12.2021.
//

import Foundation

// These are the URLs of our Back End endpoints (we force-unwrap it, since we will be adding it ourselves).
private let apiURL = URL(string: "")!

// This function returns the URL of a file "favoriteRooms.data" from the user's Documents folder.
func getFileURL() -> URL {
    guard let documentsFolder: URL =
        try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            fatalError("Can't find documents directory.")
        }
    return documentsFolder.appendingPathComponent("favoriteRooms.data")
}

extension FileManager {
  static func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: ""
    )!
  }
}
    
public final class DataHandler {
    
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
                    let parsed = try JSONDecoder().decode([Room].self, from: raw)
                    completionHandler(parsed, nil)
                } catch {
                    fatalError("Couldn't parse \(raw) as \([Room].self).")
                }
            }
        }
        .resume()
    }
    
    // This function handles the load of Favorites saved to the App's Documents folder.
    func loadLocalData(completionHandler:@escaping (Set<Int>?, Error?) -> ()) {
        let fileURL = FileManager.sharedContainerURL().appendingPathComponent("favoriteRooms.data")
        
        guard let data = try? Data(contentsOf: fileURL) else { print("ERROR!!!!"); return }
        
        guard let favoriteRooms = try? JSONDecoder().decode(Set<Int>.self, from: data) else {
            print("Can't decode saved room favorites data. Is it first run?")  // FOR DEBUGGING
            return
        }
        
        completionHandler(favoriteRooms, nil)
    }
}
