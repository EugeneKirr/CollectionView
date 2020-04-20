//
//  NetworkManager.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 16/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private let urlString = "https://collection-view-game.herokuapp.com/user_scores"
    
    func fetchRawModel<M: Codable, E: NetworkErrorHandling>(completionHandler: @escaping (Result<M, E>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let fetchedResult: Result<M, E> = self.parseJSONtoRawModel(data: data)
            DispatchQueue.main.async {
                completionHandler(fetchedResult)
            }
        }
        task.resume()
    }
    
    func postNewScore<M: RawScorePosting , E: NetworkErrorHandling>(_ name: String, _ score: Int, completionHandler: @escaping (Result<M, E>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let newRawScoreToPost = M(name, score)
        guard let jsonData = try? encoder.encode(newRawScoreToPost) else { print("can't encode"); return }
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { (data, _, _) in
            guard let data = data else { return }
            let responseResult: Result<M, E> = self.parseJSONtoRawModel(data: data)
            DispatchQueue.main.async {
                completionHandler(responseResult)
            }
        }
        task.resume()
    }
    
    private func parseJSONtoRawModel<M: Codable, E: NetworkErrorHandling>(data: Data) -> Result<M, E> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let rawModel = try? decoder.decode(M.self, from: data) else {
            let errorString = String(data: data, encoding: .utf8)
            let networkError = E(errorDescription: errorString ?? "Unknown error")
            return .failure(networkError)
        }
        return .success(rawModel)
    }

}
