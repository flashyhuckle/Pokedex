//
//  ViewController.swift
//  Pokedex
//
//  Created by Marcin Głodzik on 30/05/2023.
//

import UIKit

class ViewController: UIViewController {
    
    let manager = APIManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        manager.performRequest()
    }


}

