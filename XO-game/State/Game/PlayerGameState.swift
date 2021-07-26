//
//  PlayerGameState.swift
//  XO-game
//
//  Created by Veaceslav Chirita on 19.07.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class PlayerGameState: GameState {
    var isMoveCompleted: Bool = false
    let player: Player!
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
        guard !isMoveCompleted else { return }
        
        while ((gameViewControler?.gameboardView.canPlaceMarkView(at: position)) == true) {
            Logger.shared.log(action: .playerSetMarkView(player: player, position: position))
            gameViewControler?.gameboardView.placeMarkView(markViewPrototype, at: position)
            gameViewControler?.gameBoard.setPlayer(player, at: position)
            
            isMoveCompleted = true
        }
    }
    
    func begin() {
        switch player {
        case .first:
            gameViewControler?.firstPlayerTurnLabel.isHidden = false
            gameViewControler?.secondPlayerTurnLabel.isHidden = true
        case .second:
            gameViewControler?.firstPlayerTurnLabel.isHidden = true
            gameViewControler?.secondPlayerTurnLabel.isHidden = false
        case .none:
            break
        }
        
        gameViewControler?.winnerLabel.isHidden = true
    }
    
    
}
