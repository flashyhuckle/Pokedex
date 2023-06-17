import Foundation

final class LandingViewModel {
    private let didTapSearchButton: ((PokemonGeneration) -> Void)?
    
    init(
        didTapSearchButton: ((PokemonGeneration) -> Void)?
    ) {
        self.didTapSearchButton = didTapSearchButton
    }
    
    func tapSearch(generation: PokemonGeneration) {
        didTapSearchButton?(generation)
    }
}
