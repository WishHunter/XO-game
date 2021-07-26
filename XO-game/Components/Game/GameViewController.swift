//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    public var gameBoard = Gameboard()
    private lazy var referee = Referee(gameboard: gameBoard)
    
    private let fiveGame: FiveGameInvoker = FiveGameInvoker()
    private var activePlayer: Player = .first
    
    private var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstPlayerTurn()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.step(position: position)
        }
    }
    
    func step(position: GameboardPosition) {
        switch GameSingleton.share.typeGame {
        case .classic:
            self.currentState.addSign(at: position)
            if self.currentState.isMoveCompleted {
                self.nextPlayerTurn()
            }
        case .experimental:
            self.currentState = PlayerGameState(player: self.activePlayer, gameViewControler: self,
                                                gameBoard: self.gameBoard,
                                                gameboardView: self.gameboardView,
                                           markViewPrototype: self.activePlayer.markViewPrototype)
            
            self.currentState.addSign(at: position)
            
            self.fiveGame.addStatesCommand(state: FivesGameCommand(position: position, markViewPrototype: self.activePlayer.markViewPrototype))
            self.execute()
        }
    }
    
    
    func execute() {
        guard fiveGame.states.count >= fiveGame.bufferStates else { return }
        
        if fiveGame.states.count == fiveGame.bufferStates {
            gameboardView.clear()
            nextPlayerTurn()
        }
        
        activePlayer = .second
                
        if fiveGame.states.count == fiveGame.bufferStates * 2 {
            gameboardView.clear()
            gameBoard.clear()
            
            firstPlayerTurn()
            
            gameboardView.onSelectPosition = nil
            viewStepsGame()
        }
    }
    
    func viewStepsGame() {
        var steps: [FivesGameCommand] = []
        for index in 0..<fiveGame.bufferStates {
            steps.append(fiveGame.states[index])
            steps.append(fiveGame.states[fiveGame.bufferStates + index])
        }
                
        steps.forEach { step in
            
            // Все равно не отрисовывает последовательно(
            // sleep(1)

            if !gameboardView.canPlaceMarkView(at: step.position) {
                gameboardView.removeMarkView(at: step.position)
            }
            
            self.currentState.addSign(at: step.position)
            if self.currentState.isMoveCompleted {
                print(step.position)
                self.nextPlayerTurn()
            }
        }
    }
    
    
    private func firstPlayerTurn() {
        let firstPlayer: Player = .first
        currentState = PlayerGameState(player: firstPlayer, gameViewControler: self,
                                       gameBoard: gameBoard,
                                       gameboardView: gameboardView,
                                       markViewPrototype: firstPlayer.markViewPrototype)
        
    }
    
    private func nextPlayerTurn() {
        if let winner = referee.determineWinner() {
            currentState = GameEndState(winnerPlayer: winner, gameViewControler: self)
            Logger.shared.log(action: .gameFinished(winner: winner))
            return
        }
        
        if gameboardView.markViewForPosition.count >= 9 {
            Logger.shared.log(action: .gameFinished(winner: nil))
            currentState = GameEndState(winnerPlayer: nil, gameViewControler: self)
            return
        }
        
        if let playerState = currentState as? PlayerGameState {
            let nextPlayer = playerState.player.next
            
            switch GameSingleton.share.secondPlayer {
            case .player:
                currentState = PlayerGameState(player: nextPlayer,
                                               gameViewControler: self,
                                               gameBoard: gameBoard,
                                               gameboardView: gameboardView,
                                               markViewPrototype: nextPlayer.markViewPrototype)
            case .computer:
                currentState = ComputerGameState(player: nextPlayer,
                                               gameViewControler: self,
                                               gameBoard: gameBoard,
                                               gameboardView: gameboardView,
                                               markViewPrototype: nextPlayer.markViewPrototype)
                if self.currentState.isMoveCompleted {
                    self.nextPlayerTurn()
                }
            }
        }
        
        if let playerState = currentState as? ComputerGameState {
            let nextPlayer = playerState.player.next
            currentState = PlayerGameState(player: nextPlayer,
                                           gameViewControler: self,
                                           gameBoard: gameBoard,
                                           gameboardView: gameboardView,
                                           markViewPrototype: nextPlayer.markViewPrototype)
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        gameboardView.clear()
        gameBoard.clear()
        
        firstPlayerTurn()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.step(position: position)
        }
        
        activePlayer = .first
        fiveGame.clear()
        
        Logger.shared.log(action: .restartGame)
    }
}

