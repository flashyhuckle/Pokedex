import UIKit

protocol ApiManagerInterface {
    func getPokemonList(generation: String, onCompletion: @escaping ((Swift.Result<[Pokemon], Error>) -> Void))
    
    func getPokemonData(of pokemon: Pokemon, onCompletion: @escaping ((Swift.Result<Pokemon, Error>) -> Void))
    
    func getPokemonAvatar(of pokemon: Pokemon, onCompletion: @escaping ((Swift.Result<Pokemon, Error>) -> Void))
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
    var number: Int? = nil
    let name: String
    var height: Int? = nil
    var weight: Int? = nil
    var image: UIImage? = nil
    var imageURL: String? = nil
    var mainType: String? = nil
   
}

struct APIManager: ApiManagerInterface {
    
    func getPokemonList(generation: String, onCompletion: @escaping ((Result<[Pokemon], Error>) -> Void)) {
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
                        var pokemonArray = [Pokemon]()
                        for i in 0...decodedData.results.count - 1 {
                            pokemonArray.append(Pokemon(name: decodedData.results[i].name))
                        }
                        onCompletion(.success(pokemonArray))
                    }
                } catch {
                    
                }
            }
        })
        dataTask.resume()
    }
    
    func getPokemonData(of pokemon: Pokemon, onCompletion: @escaping ((Result<Pokemon, Error>) -> Void)) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/"
        let request = NSMutableURLRequest(url: NSURL(string: urlString + pokemon.name)! as URL,
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
                        let pokemon = Pokemon(number: decodedData.id, name: decodedData.forms[0].name, height: decodedData.height, weight: decodedData.weight, imageURL: decodedData.sprites.other.official.front_default, mainType: decodedData.types[0].type.name)
                        onCompletion(.success(pokemon))
                    }
                } catch {
                    
                }
            }
        })
        dataTask.resume()
    }
    
    
    func getPokemonAvatar(
        of pokemon: Pokemon,
        onCompletion: @escaping ((Swift.Result<Pokemon, Error>) -> Void)
    ) {
        guard let imageURL = pokemon.imageURL else { return }
        if let url = URL(string: imageURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        guard let image = UIImage(data: data) else { return }
                        let completePokemon = Pokemon(number: pokemon.number, name: pokemon.name, height: pokemon.height, weight: pokemon.weight, image: image, imageURL: pokemon.imageURL, mainType: pokemon.mainType)
                        onCompletion(.success(completePokemon))
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
