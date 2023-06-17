import UIKit

protocol ApiManagerInterface {
    func getPokemonList(generation: String, onCompletion: @escaping ((Swift.Result<PokemonListResponse, Error>) -> Void))
    
    func getPokemonData(of pokemon: String, onCompletion: @escaping ((Swift.Result<PokemonResponse, Error>) -> Void))
    
    func getPokemonAvatar(with url: String, onCompletion: @escaping ((Swift.Result<UIImage, Error>) -> Void))
}

struct PokemonListResponse: Decodable {
    let results: [Pokemon]
    
    struct Pokemon: Decodable {
        let name: String
    }
}

struct PokemonResponse: Decodable {
    let forms: [Form]
    let height: Int
    let weight: Int
    let sprites: Sprites
    let types: [Types]
    let id: Int
    
    struct Form: Decodable {
        let name: String
    }
    
    struct Sprites: Decodable {
        let other: Other
        let front_default: String
    }
    
    struct Other: Decodable {
        let official: Official
        
        private enum CodingKeys: String, CodingKey {
            case official = "official-artwork"
        }
    }
    
    struct Official: Decodable {
        let front_default: String
    }
    
    struct Types: Decodable {
        let type: PokemonType
    }
    struct PokemonType: Decodable {
        let name: String
    }
}

struct Pokemon {
    let number: Int
    let name: String
    let height: Int
    let weight: Int
    let image: UIImage
    let mainType: String
}

struct APIManager: ApiManagerInterface {
    
    func getPokemonList(generation: String, onCompletion: @escaping ((Result<PokemonListResponse, Error>) -> Void)) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/" + generation
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                do {
                    let decodedData = try JSONDecoder().decode(PokemonListResponse.self, from: data!)
                    DispatchQueue.main.async {
                        onCompletion(.success(decodedData))
                    }
                } catch {
                    
                }
            }
        })
        dataTask.resume()
    }
    
    func getPokemonData(of pokemon: String, onCompletion: @escaping ((Result<PokemonResponse, Error>) -> Void)) {
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
                do {
                    let decodedData = try JSONDecoder().decode(PokemonResponse.self, from: data!)
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
