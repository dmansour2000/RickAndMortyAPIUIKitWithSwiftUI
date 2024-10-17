//
//  CharacterService.swift
//  ChararactersApp
//
//  Created by Dina Mansour  on 17/10/2024.
//

import Foundation
import Combine
import SwiftUI
import RickMortySwiftApi
// character api - https://rickandmortyapi.com/api/character

class CharacterService: ObservableObject {
    // be responsible for character fetctes made
    @Published var characters: [RMCharacterModel] = []
    @Published var isLoading: Bool = true
    @Published var isCharactersFetched: Bool = true
    @Published var rmClient: RMClient = RMClient()
    
    var cancellables = Set<AnyCancellable>()
    var characterSubscription: AnyCancellable?
    
    init() {
        Task.detached{
            try await self.characters = self.rmClient.character().getAllCharacters()
        }
    }
    
   
    func filteredCharacters(filter: Filters) -> [RMCharacterModel] {
        switch filter {
        case .alive:
            return characters.filter { $0.status == "Alive" }
        case .dead:
            return characters.filter { $0.status == "Dead" }
        case .unknown:
            return characters.filter { $0.status == "unknown" }
        case .all:
            return characters
        }
    }
    
   
    func downlaodData(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
}
enum Filters: String, Codable, CaseIterable {
    case all = "All"
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "Unknown"
}
