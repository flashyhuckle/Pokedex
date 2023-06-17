import UIKit

struct LandingScreens {
    func createLandingViewController(didTapSearchButton: ((PokemonGeneration) -> Void)?) -> UIViewController {
        let viewModel: LandingViewModel = .init(didTapSearchButton: didTapSearchButton)
        return LandingViewController(viewModel: viewModel)
    }
}
