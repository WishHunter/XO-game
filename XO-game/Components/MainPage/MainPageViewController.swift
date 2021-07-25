//
//  MainPageViewController.swift
//  XO-game
//
//  Created by Denis Molkov on 25.07.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    @IBOutlet weak var countPlayers: UISegmentedControl!
    @IBOutlet weak var typeGame: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countPlayers.selectedSegmentIndex = GameSingleton.share.secondPlayer.rawValue
        typeGame.selectedSegmentIndex = GameSingleton.share.typeGame.rawValue
        
        countPlayers.addTarget(self, action: #selector(countPlayersChanged(_:)), for: .valueChanged)
        typeGame.addTarget(self, action: #selector(typeGameChanged(_:)), for: .valueChanged)
    }
    
    @objc func countPlayersChanged(_ segControl: UISegmentedControl) {
        switch countPlayers.selectedSegmentIndex {
        case 0:
            GameSingleton.share.secondPlayer = .player
        case 1:
            GameSingleton.share.secondPlayer = .computer
        default:
            GameSingleton.share.secondPlayer = .player
        }
    }
    
    @objc func typeGameChanged(_ segControl: UISegmentedControl) {
        switch typeGame.selectedSegmentIndex {
        case 0:
            GameSingleton.share.typeGame = .classic
        case 1:
            GameSingleton.share.typeGame = .experimental
        default:
            GameSingleton.share.typeGame = .classic
        }
    }
    
}
