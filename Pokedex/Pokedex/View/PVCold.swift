import UIKit

class PVC: UIViewController {
    
    var pokemonList = [Pokemon]()
    private let viewModel: PokedexViewModel
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
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
        tableView.dataSource = self
        
        viewModel.didReceivePokemonData = { pokemon in
            self.pokemonList.append(pokemon)
//            self.pokemonList.sort {
//                $0.number < $1.number
//            }
            self.tableView.reloadData()
        }
        
        viewModel.getPokemonList()
    }
    
    func setUpViews() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.backgroundColor = .none
            cell.textLabel?.text = pokemonList[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
            
            if pokemonList[indexPath.row].mainType == "grass" {
                cell.backgroundColor = .green
            }
            
            return cell
        }
        return UITableViewCell()
    }
}
