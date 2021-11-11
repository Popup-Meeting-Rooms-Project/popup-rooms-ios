//
//  Room.swift
//  PopUpRooms
//
//  Created by ernven on 22.10.2021.
//

import Foundation

struct Room : Identifiable, Codable {
    
    //var id = UUID()       NOT USED ATM
    var id: Int
    let roomName: String
    let floor: Int
    var busy: Bool
    var starred: Bool
    
    // This helps "translate" our object properties to those of the JSON data provided, to avoid mismatches.
    private enum CodingKeys: String, CodingKey {
        case roomName = "room_name"
        case busy = "detected"
        case floor = "building_floor"
        case id, starred
    }
    
    // This custom init helps set the starred property, which isn't included in the JSON data.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.roomName = try container.decodeIfPresent(String.self, forKey: .roomName) ?? "Room"
        self.floor = try container.decode(Int.self, forKey: .floor)
        self.busy = try container.decode(Bool.self, forKey: .busy)
        // Here we use the method decodeIfPresent instead
        //self.starred = try container.decodeIfPresent(Bool.self, forKey: .starred) ?? false
        self.starred = false
        
    }
}
