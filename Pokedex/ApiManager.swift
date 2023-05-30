//
//  ApiManager.swift
//  Pokedex
//
//  Created by Marcin Głodzik on 30/05/2023.
//

import Foundation

struct pokemonResponse: Decodable {
    let forms: [Form]
    let height: Int
    let weight: Int
    
    struct Form: Decodable {
        let name: String
    }
}



struct APIManager {
    
    func performRequest() {
        
        let urlString = "https://pokeapi.co/api/v2/pokemon/pikachu"
        
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
//                print(httpResponse)
                do {
                    let decodedData = try JSONDecoder().decode(pokemonResponse.self, from: data!)
                    
                    print(decodedData)
                } catch {
                    
                }
            }
        })
        
        dataTask.resume()
    }
    
}
