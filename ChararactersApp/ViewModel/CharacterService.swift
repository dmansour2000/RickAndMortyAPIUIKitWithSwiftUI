//
//  CharacterService.swift
//  ChararactersApp
//
//  Created by Dina Mansour  on 17/10/2024.
//

import Foundation
import Combine
import SwiftUI

protocol MoviesService: AnyObject {
  /// Get a list of the current popular movies on TMDB.
  /// - Parameter page: Specify which page to query.
  ///                   Validation: minimum: 1, maximum: 1000, default: 1
  func getPaginatedCharacters(page: Int) async throws -> CharactersResult
func getPaginatedFilteredCharacters(page: Int, statusFilter: Status) async throws -> CharactersResult
}

final class CharacterService: ObservableObject {
    // be responsible for character fetctes made
    @Published var characters: [Characters] = []
    @Published var returnedCharacter: Characters?
    @Published var isLoading: Bool = true
    @Published var isCharactersFetched: Bool = true
    private let decoder: JSONDecoder
    
    var cancellables = Set<AnyCancellable>()
    var characterSubscription: AnyCancellable?
    
    init() {
        self.decoder = JSONDecoder()
        self.characters =  getCharacters()
    }
    func getCharacters() -> [Characters] {
        guard let url1 = URL(string: Constants.baseURL + Constants.characters + "/?page=1") else { return [] }
        guard let url2 = URL(string: Constants.baseURL + Constants.characters + "/?page=2") else { return []}
        guard let url3 = URL(string: Constants.baseURL + Constants.characters + "/?page=3") else { return []}
        guard let url4 = URL(string: Constants.baseURL + Constants.characters + "/?page=4") else { return [] }
        guard let url5 = URL(string: Constants.baseURL + Constants.characters + "/?page=5") else { return []}
        guard let url6 = URL(string: Constants.baseURL + Constants.characters + "/?page=6") else { return []}
        guard let url7 = URL(string: Constants.baseURL + Constants.characters + "/?page=7") else { return []}
        guard let url8 = URL(string: Constants.baseURL + Constants.characters + "/?page=8") else { return []}
        guard let url9 = URL(string: Constants.baseURL + Constants.characters + "/?page=9") else { return []}
        guard let url10 = URL(string: Constants.baseURL + Constants.characters + "/?page=10") else { return []}
        
        let publishers = [url1,url2,url3,url4,url5,url6,url7,url8,url9,url10].map { url in
            URLSession.shared.dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap(downloadData)
                .decode(type: CharacterResponse.self, decoder: JSONDecoder())
                .map { $0.results } // Extract character results
                .eraseToAnyPublisher()
        }
        
        Publishers.MergeMany(publishers)
            .collect()
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] allCharacters in
                self?.characters = allCharacters.flatMap { $0 }
                self?.isCharactersFetched = false
            }
            .store(in: &cancellables)
        
        return self.characters
    }
    
    func filteredCharacters(filter: Filters) -> [Characters] {
        switch filter {
        case .alive:
            return characters.filter { $0.status == .alive }
        case .dead:
            return characters.filter { $0.status == .dead }
        case .unknown:
            return characters.filter { $0.status == .unknown }
        case .all:
            return characters
        }
    }
    
    func getPaginatedFilteredCharacters(page: Int, statusFilter: Status) async throws -> CharactersResult {
        let baseURL: URL = URL(string: Constants.baseURL )!
        let url = baseURL.appendingPathComponent(Constants.characters)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "status", value: statusFilter.rawValue),
            URLQueryItem(name: "language", value: "en-US"),
        ]
       
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = ["accept": "application/json"]
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    
        return try decoder.decode(CharactersResult.self, from: data)
    }
    
    func getPaginatedCharacters(page: Int) async throws -> CharactersResult {
        let baseURL: URL = URL(string: Constants.baseURL )!
        let url = baseURL.appendingPathComponent(Constants.characters)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "language", value: "en-US"),
        ]
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = ["accept": "application/json"]
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try decoder.decode(CharactersResult.self, from: data)
    }
    
    
   
    func downloadData(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
}

