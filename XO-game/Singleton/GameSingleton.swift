//
//  GameSingleton.swift
//  XO-game
//
//  Created by Denis Molkov on 24.07.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation


class GameSingleton {
    static let share = GameSingleton()
    
    private init() {}
    
    var secondPlayer: SecondPlayer = .player
    var typeGame: TypeGame = .experimental
}

enum SecondPlayer: Int {
    case player, computer
}

enum TypeGame: Int {
    case classic, experimental
}
