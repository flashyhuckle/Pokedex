//
//  ViewController.swift
//  Pokedex
//
//  Created by Marcin Głodzik on 30/05/2023.
//

import UIKit

class ViewController: UIViewController {
    
    var pokemonArray = [""]
    lazy var selectedPokemon = pokemonArray[0]
    
    let manager = APIManager()
    
    private lazy var VCPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .gray
        return pickerView
    }()
    
    private lazy var searchButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Search", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pokedex), for: .touchUpInside)
        return button
    }()
    
    private lazy var label: UILabel = {
        let label: UILabel = UILabel()
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let image: UIImageView = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        VCPickerView.dataSource = self
        VCPickerView.delegate = self
        
        setUpView()
        getPokemonList()
    }
    
    private func setUpView() {
        view.addSubview(VCPickerView)
        view.addSubview(searchButton)
        view.addSubview(label)
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            VCPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            VCPickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            
            searchButton.heightAnchor.constraint(equalToConstant: 100),
            searchButton.widthAnchor.constraint(equalToConstant: 200),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.topAnchor.constraint(equalTo: VCPickerView.bottomAnchor, constant: 20),
            
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 20),
            
            label.heightAnchor.constraint(equalToConstant: 100),
            label.widthAnchor.constraint(equalToConstant: 400),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        ])
    }
    
    func getPokemonList() {
        manager.fetchPokemonList { response in
            switch response {
                case .success(let pokemonList):
                self.pokemonArray = [String]()
                for i in 0..<pokemonList.results.count {
                    self.pokemonArray.append(pokemonList.results[i].name)
                }
                self.VCPickerView.reloadAllComponents()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func pokedex() {
        manager.fetchPokemonData(of: selectedPokemon) { response in
            switch response {
            case .success(let pokemon):
                self.getAvatar(string: pokemon.sprites.front_default)
                self.label.text = pokemon.forms[0].name + " " + "height: \(Double(pokemon.height)/10), weight \(Double(pokemon.weight)/10)"
            case .failure(let error):
                print(error)
            }
        }
    }
    func getAvatar(string: String) {
        manager.getPokemonAvatar(with: string) { response in
            switch response {
            case .success(let image):
                self.imageView.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pokemonArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pokemonArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPokemon = pokemonArray[row]
    }
}
