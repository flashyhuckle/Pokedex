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
            case .failure(let error):
                print(error)
            }
        }
    }
}
