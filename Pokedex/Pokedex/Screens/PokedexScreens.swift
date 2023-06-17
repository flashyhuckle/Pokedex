import UIKit

struct PokedexScreens {
    func createPokedexViewController(generation: PokemonGeneration) -> PokedexViewController {
        let apiManager = APIManager()
        let viewModel = PokedexViewModel(generation: generation, apiManager: apiManager)
        return PokedexViewController(viewModel: viewModel)
    }
}
