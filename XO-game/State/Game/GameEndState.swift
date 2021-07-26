//
//  GameEndState.swift
//  XO-game
//
//  Created by Veaceslav Chirita on 19.07.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class GameEndState: GameState {
    var isMoveCompleted: Bool = false
    
    public let winnerPlayer: Player?
    weak var gameViewControler: GameViewController?
    
    init(winnerPlayer: Player?, gameViewControler: GameViewController) {
        self.winnerPlayer = winnerPlayer
        self.gameViewControler = gameViewControler
    }
    
    func addSign(at position: GameboardPosition) {}
    
    func begin() {
        gameViewControler?.winnerLabel.isHidden = false
        
        if let winnerPlayer = winnerPlayer {
            gameViewControler?.winnerLabel.text = setPlayerName(player: winnerPlayer) + " won"
        } else {
            gameViewControler?.winnerLabel.text = "No winner/Draw"
        }
        
        gameViewControler?.firstPlayerTurnLabel.isHidden = true
        gameViewControler?.secondPlayerTurnLabel.isHidden = true
    }
    
    private func setPlayerName(player: Player) -> String {
        switch player {
        case .first:
            return "First"
        case .second:
            return "Second"
        }
    }
    
}
