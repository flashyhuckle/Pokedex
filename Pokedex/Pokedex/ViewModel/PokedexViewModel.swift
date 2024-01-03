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
    
    var pokemonArray = [Pokemon]() {
        didSet {
            didReceivePokemonList?(pokemonArray)
        }
    }
    
    //MARK: Output
    var didReceivePokemonList: (([Pokemon]) -> Void)?
    
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
                self.didReceivePokemonList?(pokemonList)
                self.pokemonArray = pokemonList
                self.getPokemonData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPokemonData() {
        for pokemon in pokemonArray {
            apiManager.getPokemonData(of: pokemon) { result in
                switch result {
                case .success(let pokemon):
                    self.getCompletePokemon(pokemon)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getCompletePokemon(_ pokemon: Pokemon) {
        let offset: Int = {
            switch generation {
            case .Generation1:
                return 1
            case .Generation2:
                return 152
            case .Generation3:
                return 252
            }
        }()
        apiManager.getPokemonAvatar(of: pokemon) { result in
            switch result {
            case .success(let completePokemon):
                guard let position = completePokemon.number else { return }
                self.pokemonArray.remove(at: position - offset)
                self.pokemonArray.insert(completePokemon, at: position - offset)
            case .failure(let error):
                print(error)
            }
        }
    }
}
