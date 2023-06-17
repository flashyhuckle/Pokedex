//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by Marcin Głodzik on 16/06/2023.
//

import Foundation

final class PokedexViewModel {
    
    //MARK: Input
    let generation: PokemonGeneration
    let apiManager: ApiManagerInterface
    
    //MARK: Output
    var didReceivePokemonList: ((PokemonListResponse) -> Void)?
    var didReceivePokemonData: ((Pokemon) -> Void)?
    
    //MARK: Initialization
    init(
        generation: PokemonGeneration,
        apiManager: ApiManagerInterface
    ) {
        self.generation = generation
        self.apiManager = apiManager
    }
    
    func getPokemonList() {
        apiManager.getPokemonList(generation: generation.rawValue) { result in
            switch result {
            case .success(let pokemonList):
//                self.didReceivePokemonList?(pokemonList)
                for i in 0..<pokemonList.results.count {
                    self.getPokemonData(pokemon: pokemonList.results[i].name)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPokemonData(pokemon: String) {
        apiManager.getPokemonData(of: pokemon) { result in
            switch result {
            case .success(let pokemon):
                self.createPokemonStruct(pokemon: pokemon)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createPokemonStruct(pokemon: PokemonResponse) {
        apiManager.getPokemonAvatar(with: pokemon.sprites.other.official.front_default) { result in
            switch result {
            case .success(let image):
                let pokemonStruct = Pokemon(number: pokemon.id,name: pokemon.forms[0].name, height: pokemon.height, weight: pokemon.weight, image: image, mainType: pokemon.types[0].type.name)
                self.didReceivePokemonData?(pokemonStruct)
            case .failure(let error):
                print(error)
            }
        }
    }
}
