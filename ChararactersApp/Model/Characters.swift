//
//  Characters.swift
//  ChararactersApp
//
//  Created by Dina Mansour  on 20/10/2024.
//

import Foundation

struct CharacterResponse: Codable {
    let results: [Characters]
}


// MARK: - Result
struct Characters: Codable, Identifiable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    // safe unwrap url
    var urlString: URL {
        let url = URL(string: url)
        return url!
    }
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}

enum Filters: String, Codable, CaseIterable {
    case all = "All"
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "Unknown"
}


enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let url: String
}

struct CharactersResult: Codable {
  var page: Int?
  var totalPages: Int?
  var totalResults: Int?
  let results: [Characters]?
}
