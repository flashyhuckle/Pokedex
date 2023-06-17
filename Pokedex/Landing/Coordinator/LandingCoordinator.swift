import UIKit

protocol CoordinatorType {
    func start()
}

final class LandingCoordinator: CoordinatorType {
    
    //MARK: Properties
    private var navigationController: UINavigationController = UINavigationController()
    private var screens: LandingScreens = LandingScreens()
    private let presenter: UIWindow
    
    //MARK: Child coordinators
    private var pokedexCoordinator: PokedexCoordinator?
    
    //MARK: Initialization
    init(presenter: UIWindow) {
        self.presenter = presenter
    }
    
    //MARK: Start
    func start() {
        let landingViewController = screens.createLandingViewController { selectedGeneration in
            self.pokedexCoordinator = PokedexCoordinator(presenter: self.navigationController, generation: selectedGeneration)
            self.pokedexCoordinator?.start()
        }
        navigationController.viewControllers = [landingViewController]
        presenter.rootViewController = navigationController
    }
}
