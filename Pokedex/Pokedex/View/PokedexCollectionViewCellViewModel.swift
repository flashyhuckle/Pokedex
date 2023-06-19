import UIKit

final class PokedexCollectionViewCellViewModel {
    
    // MARK: - Input
    let apiManager: ApiManagerInterface
    
    // MARK: - Output
    var didReceivePokemonData: ((PokemonResponse) -> Void)?
    var didReceiveAvatar: ((UIImage?) -> Void)?
    
    // MARK: - Initialization
    init(
        apiManager: ApiManagerInterface
    ) {
        self.apiManager = apiManager
    }
    
    //MARK: - Lifecycle
    func getPokemonData(pokemon: String) {
        apiManager.getPokemonData(of: pokemon) { result in
            switch result {
            case .success(let pokemon):
                self.didReceivePokemonData?(pokemon)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func getPokemonAvatar(pokemon: String) {
        apiManager.getPokemonAvatar(with: pokemon) { result in
            switch result {
            case .success(let avatar):
                self.didReceiveAvatar?(avatar)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
