//
//  ApiManager.swift
//  Pokedex
//
//  Created by Marcin Głodzik on 30/05/2023.
//

import UIKit

protocol ApiManagerInterface {
    func fetchPokemonList(onCompletion: @escaping ((Swift.Result<pokemonListResponse, Error>) -> Void))
    
    func fetchPokemonData(of pokemon: String, onCompletion: @escaping ((Swift.Result<pokemonResponse, Error>) -> Void))
    
    func getPokemonAvatar(with url: String, onCompletion: @escaping ((Swift.Result<UIImage, Error>) -> Void))
}

struct pokemonListResponse: Decodable {
    let results: [pokemon]
    
    struct pokemon: Decodable {
        let name: String
    }
}

struct pokemonResponse: Decodable {
    let forms: [Form]
    let height: Int
    let weight: Int
    let sprites: Sprites
    
    struct Form: Decodable {
        let name: String
    }
    
    struct Sprites: Decodable {
        let front_default: String
    }
}

struct APIManager: ApiManagerInterface {
    
    func fetchPokemonList(onCompletion: @escaping ((Result<pokemonListResponse, Error>) -> Void)) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/?limit=151"
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                do {
                    let decodedData = try JSONDecoder().decode(pokemonListResponse.self, from: data!)
                    DispatchQueue.main.async {
                        onCompletion(.success(decodedData))
                    }
                } catch {
                    
                }
            }
        })
        
        dataTask.resume()
    }
    
    func fetchPokemonData(of pokemon: String, onCompletion: @escaping ((Result<pokemonResponse, Error>) -> Void)) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/"
        let request = NSMutableURLRequest(url: NSURL(string: urlString + pokemon)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
//                print(httpResponse)
                do {
                    let decodedData = try JSONDecoder().decode(pokemonResponse.self, from: data!)
                    DispatchQueue.main.async {
                        onCompletion(.success(decodedData))
                    }
                } catch {
                    
                }
            }
        })
        dataTask.resume()
    }
    
    
    func getPokemonAvatar(
        with url: String,
        onCompletion: @escaping ((Swift.Result<UIImage, Error>) -> Void)
    ) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        onCompletion(.success(UIImage(data: data)!))
                    }
                }
                if let error = error {
                    DispatchQueue.main.async {
                        onCompletion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
    
}
