//
//  EventDataStructs.swift
//  LetsSeeAShow
//
//  Created by Jay Fein on 12/3/19.
//  Copyright © 2019 Jay Fein. All rights reserved.
//

import Foundation

struct EventData : Codable {
    let events : [Event]
}

struct Event : Codable {
    let id : Int
    let stats : Stats
    let datetime_local : String
    let performers : [Performer]
    let url : String
    let venue : Venue
    let short_title : String
}

struct Stats : Codable {
    let median_price : Int
}

struct Performer : Codable {
    let image : String?
    let genres : [Genre]?
}

struct Genre : Codable {
    let name : String?
}

struct Venue : Codable {
    let display_location : String
    let location : Location
}

struct Location : Codable {
    let lat : Double
    let lon : Double
}
