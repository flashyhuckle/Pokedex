import UIKit

final class PokedexViewController: UIViewController {
    
    private var pokemonList = [Pokemon]()
    private let viewModel: PokedexViewModel
    
    //MARK: Views
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.itemSize = .init(width: 180, height: 100)
        return layout
    }()
    
    private lazy var pokedexCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PokedexCollectionViewCell.self, forCellWithReuseIdentifier: "PokedexCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    //MARK: Initialization
    
    init(viewModel: PokedexViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        viewModel.didReceivePokemonData = { pokemon in
            self.pokemonList.append(pokemon)
            self.pokemonList.sort {
                $0.number < $1.number
            }
            self.pokedexCollectionView.reloadData()
        }
        viewModel.getPokemonList()
    }
    
    func setUpViews() {
        pokedexCollectionView.backgroundColor = .lightGray
        view.addSubview(pokedexCollectionView)
        
        NSLayoutConstraint.activate([
            pokedexCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pokedexCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            pokedexCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pokedexCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PokedexViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokedexCollectionViewCell", for: indexPath) as? PokedexCollectionViewCell else { return UICollectionViewCell() }
        cell.update(pokemon: pokemonList[indexPath.row])
        return cell
    }
    
    
}

