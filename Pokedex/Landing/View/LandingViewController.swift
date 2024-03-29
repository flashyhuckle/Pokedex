//
//  ViewController.swift
//  Pokedex
//
//  Created by Marcin Głodzik on 30/05/2023.
//

import UIKit

enum PokemonGeneration: String, CaseIterable {
    
    case Generation1 = "?limit=151"
    case Generation2 = "?offset=151&limit=100"
    case Generation3 = "?offset=251&limit=135"
    
}

class LandingViewController: UIViewController {
    
    private let viewModel: LandingViewModel
    
    lazy var selectedGeneration = PokemonGeneration.Generation1
    
//    let manager = APIManager()
    
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
        button.addTarget(self, action: #selector(getPokemonList), for: .touchUpInside)
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
    
    init(
        viewModel: LandingViewModel
    ){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        VCPickerView.dataSource = self
        VCPickerView.delegate = self
        
        setUpView()
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
    
    @objc func getPokemonList() {
        viewModel.tapSearch(generation: selectedGeneration)
    }
}

extension LandingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PokemonGeneration.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(PokemonGeneration.allCases[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGeneration = PokemonGeneration.allCases[row]
    }
}
