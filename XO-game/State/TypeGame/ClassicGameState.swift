//
//  ClassicGameState.swift
//  XO-game
//
//  Created by Denis Molkov on 25.07.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class ClassicGameState: TypeGameState {
    var gameBoard: Gameboard
    var gameBoardView: GameboardView
    
    func firstPlayerTurn() -> GameState {
        let firstPlayer: Player = .first
        return PlayerGameState(player: firstPlayer, gameViewControler: self,
                                       gameBoard: gameBoard,
                                       gameboardView: gameboardView,
                                       markViewPrototype: firstPlayer.markViewPrototype)
    }
    
    func nextPlayerTurn() -> GameState {
        
    }
}
