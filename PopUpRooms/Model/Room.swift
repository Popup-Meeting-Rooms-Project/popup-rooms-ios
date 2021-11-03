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
    let roomNo: Int
    let floor: Int
    var status: Bool
    var starred: Bool
    
    // This helps "translate" our object properties to those of the JSON data provided, to avoid mismatches.
    private enum CodingKeys: String, CodingKey {
        case roomNo = "room_number"
        case status = "detected"
        case floor = "building_floor"
        case id, starred
    }
    
    // This custom init helps set the starred property, which isn't included in the JSON data.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.roomNo = try container.decode(Int.self, forKey: .roomNo)
        self.floor = try container.decode(Int.self, forKey: .floor)
        self.status = try container.decode(Bool.self, forKey: .status)
        // Here we use the method decodeIfPresent instead
        self.starred = try container.decodeIfPresent(Bool.self, forKey: .starred) ?? false
        
    }
}
