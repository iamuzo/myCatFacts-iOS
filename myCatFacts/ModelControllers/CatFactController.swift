//
//  CatFactController.swift
//  myCatFacts
//
//  Created by Uzo on 1/23/20.
//  Copyright © 2020 Uzo. All rights reserved.
//

import Foundation

class CatFactController {
    
    static private let baseURL = URL(string: "http://www.catfact.info/api/v1")
    static private let factsEndpoint = "facts"
    static private let factsPathExtension = "json"
    private static let contentTypeKey = "Content-Type"
    private static let contentTypeValue = "application/json"
    
    static func fetchCatFacts(page: Int, completion: @escaping (Result <[CatFact], CatFactError>) -> Void) {
        
        guard let baseURL = baseURL else {
            return completion(.failure(.invalidURL))
        }
        let factsURL = baseURL.appendingPathComponent(factsEndpoint)
        let jsonPathExtension = factsURL.appendingPathExtension(factsPathExtension)
        
        var urlComponent = URLComponents(url: jsonPathExtension, resolvingAgainstBaseURL: true)
        urlComponent?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let finalURL = urlComponent?.url else { return }
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }

            guard let data = data else {
                return completion(.failure(.noData))
            }

            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(TopLevelGETObject.self, from: data)
                let fact = data.facts
                return completion(.success(fact))
            } catch {
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func postCatFact(details: String, completion: @escaping (Result <CatFact, CatFactError>) -> Void) {

        guard let baseURL = baseURL else {
            return completion(.failure(.invalidURL))
        }
        let factsURL = baseURL.appendingPathComponent(factsEndpoint)
        let jsonPathExtension = factsURL.appendingPathExtension(factsPathExtension)

        var postRequest = URLRequest(url: jsonPathExtension)
        postRequest.httpMethod = "POST"

        postRequest.addValue(contentTypeValue, forHTTPHeaderField: contentTypeKey)

        let catFact = CatFact(id: nil, details: details)

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(catFact)
            postRequest.httpBody = data
        } catch {
            return completion(.failure(.thrownError(error)))
        }

        URLSession.shared.dataTask(with: postRequest) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }

            do {
                let decoder = JSONDecoder()
                let catFact = try decoder.decode(CatFact.self, from: data)
                return completion(.success(catFact))
            } catch {
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
}
