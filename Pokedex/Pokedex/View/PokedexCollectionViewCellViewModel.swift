import UIKit

final class PokedexCollectionViewCellViewModel {
    
    // MARK: - Dependency
    let apiManager: ApiManagerInterface
    
    // MARK: - Output
    var didReceivePokemonData: ((Pokemon) -> Void)?
    var didReceiveCompletePokemon: ((Pokemon) -> Void)?
    
    // MARK: - Initialization
    init(
        apiManager: ApiManagerInterface
    ) {
        self.apiManager = apiManager
    }
    
    //MARK: - Lifecycle
    func update(pokemon: Pokemon) {
        if pokemon.number == nil {
            didReceivePokemonData = { updatedPokemon in
                self.update(pokemon: updatedPokemon)
            }
            getPokemonData(pokemon: pokemon)
        } else if pokemon.image == nil {
            getPokemonAvatar(pokemon: pokemon)
        }
    }
    
    func getPokemonData(pokemon: Pokemon) {
        apiManager.getPokemonData(of: pokemon) { result in
            switch result {
            case .success(let pokemon):
                self.didReceivePokemonData?(pokemon)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func getPokemonAvatar(pokemon: Pokemon) {
        apiManager.getPokemonAvatar(of: pokemon) { result in
            switch result {
            case .success(let pokemon):
                self.didReceiveCompletePokemon?(pokemon)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
