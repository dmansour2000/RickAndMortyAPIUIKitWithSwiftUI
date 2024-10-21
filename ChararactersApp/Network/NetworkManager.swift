//
//  NetworkManager.swift
//  ChararactersApp
//
//  Created by Dina Mansour  on 20/10/2024.
//

import Foundation
import Combine

class NetworkManager {
    
    /// Creating custom error messages
    enum NetworkingError: LocalizedError {
        case badURLResponse
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse:
                return "Bad URL Response from URL"
            case .unknown:
                return "Unknow Error Occurred"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0 )})
            .receive(on: DispatchQueue.main)
            .retry(3) // <- retries to download the data again if the download fails 3 times
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

