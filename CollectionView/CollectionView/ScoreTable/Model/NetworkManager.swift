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
    
    func fetchRawScoreData(completionHandler: @escaping ([RawScoreData]) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let rawResult = try? decoder.decode([RawScoreData].self, from: data) else {
                guard let rawString = String(data: data, encoding: .utf8) else { return }
                print(rawString)
                return
            }
            DispatchQueue.main.async {
                completionHandler(rawResult)
            }
        }
        task.resume()
    }
    
    func postNewScore(_ name: String, _ score: Int) {
        let newRawScoreToPost = RawScoreData(name, score)
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(newRawScoreToPost) else { print("can't encode"); return }
        
        request.httpBody = jsonData
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            guard let rawString = String(data: data, encoding: .utf8) else { return }
            print(rawString)
        }
        task.resume()
    }

}
