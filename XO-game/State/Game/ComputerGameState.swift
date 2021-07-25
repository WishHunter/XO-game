//
//  ComputerGameState.swift
//  XO-game
//
//  Created by Denis Molkov on 24.07.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class ComputerGameState: GameState {
    var isMoveCompleted: Bool = false
    var player: Player!
    weak var gameViewControler: GameViewController?
    var gameBoard: Gameboard
    var gameBoardView: GameboardView
    var markViewPrototype: MarkView
    
    init(player: Player?, gameViewControler: GameViewController,
         gameBoard: Gameboard,
         gameboardView: GameboardView, markViewPrototype: MarkView) {
        self.player = player
        self.gameViewControler = gameViewControler
        self.gameBoard = gameBoard
        self.gameBoardView = gameboardView
        self.markViewPrototype = markViewPrototype
    }
    
    func addSign(at position: GameboardPosition) {
        guard !isMoveCompleted,
            (gameViewControler?.gameboardView.canPlaceMarkView(at: position)) == true else {
            turnComputer()
            return
        }
            
        Logger.shared.log(action: .playerSetMarkView(player: player, position: position))
        gameViewControler?.gameboardView.placeMarkView(markViewPrototype, at: position)
        gameViewControler?.gameBoard.setPlayer(player, at: position)
        
        isMoveCompleted = true
    }
    
    func begin() {
        gameViewControler?.firstPlayerTurnLabel.isHidden = true
        gameViewControler?.secondPlayerTurnLabel.isHidden = false
        gameViewControler?.winnerLabel.isHidden = true
        turnComputer()
    }
    
    func turnComputer() {
        let column = Int.random(in: 0..<3)
        let row = Int.random(in: 0..<3)
        print(column)
        print(row)
        let position = GameboardPosition(column: column, row: row)
        addSign(at: position)
    }
}
