import UIKit

final class PokedexCoordinator: CoordinatorType {
    
    //MARK: Properties
    
    private let screens: PokedexScreens = PokedexScreens()
    private let presenter: UINavigationController
    private let generation: PokemonGeneration
    
    //MARK: Initialization
    
    init(presenter: UINavigationController, generation: PokemonGeneration) {
        self.presenter = presenter
        self.generation = generation
    }
    
    //MARK: Start
    
    func start() {
        let pokedexViewController = screens.createPokedexViewController(generation: generation)
        presenter.pushViewController(pokedexViewController, animated: true)
    }
}
