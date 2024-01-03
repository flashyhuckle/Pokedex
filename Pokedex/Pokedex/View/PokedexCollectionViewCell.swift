import UIKit

final class PokedexCollectionViewCell: UICollectionViewCell {

    var didReceiveCompletePokemon: ((Pokemon) -> Void)?

    private let mainContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        mainContainerView.backgroundColor = .none
    }
    
    func update(
        pokemon: Pokemon
//        viewModel: PokedexCollectionViewCellViewModel
    ) {
        imageView.image = pokemon.image
        nameLabel.text = pokemon.name
        mainContainerView.backgroundColor = getPokemonBackgroudColor(pokemon: pokemon)

//        viewModel.didReceiveCompletePokemon = { [weak self] completePokemon in
//            guard let self = self else { return }
//            self.didReceiveCompletePokemon?(completePokemon)
//            self.update(pokemon: completePokemon, viewModel: viewModel)
//        }
//        
//        viewModel.update(pokemon: pokemon)
    }
    
    private func getPokemonBackgroudColor(pokemon: Pokemon) -> UIColor {
        switch pokemon.mainType {
        case "grass": return .systemGreen
        case "fire": return .systemRed
        case "water": return .systemBlue
        case "bug": return .systemGreen
        case "normal": return .white
        case "ground": return .brown
        case "electric": return .systemYellow
        case "poison": return .systemPurple
        case "fairy": return .systemMint
        case "fighting": return .systemBrown
        case "psychic": return .systemPurple
        case "rock": return .systemGray3
        case "ghost": return .systemCyan
        case "ice": return .systemMint
        case "dragon": return .systemTeal
        default: return .clear
        }
    }
    
    private func setUpLayout() {
        contentView.addSubview(mainContainerView)
        mainContainerView.addSubview(imageView)
        mainContainerView.addSubview(nameLabel)
        
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            mainContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 44.0),
            imageView.heightAnchor.constraint(equalToConstant: 44.0),
            imageView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: 10.0),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5.0),
            nameLabel.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -10.0),
            nameLabel.bottomAnchor.constraint(greaterThanOrEqualTo: mainContainerView.bottomAnchor, constant: -10.0)
        ])
    }
}
