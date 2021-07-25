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
    
    private var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }
    
    private var states: [FivesGameCommand] = []
    private let bufferStates = 5
    private var queuePlayer = firstPlayerTurn
    private var activePlayer: Player = .first
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addStatesCommand(state: FivesGameCommand(position: <#T##GameboardPosition#>, markViewPrototype: <#T##MarkView#>))
        
//        firstPlayerTurn()
        
        
//        gameboardView.onSelectPosition = { [weak self] position in
//            guard let self = self else { return }
//
//            self.currentState.addSign(at: position)
//            if self.currentState.isMoveCompleted {
//                self.nextPlayerTurn()
//            }
//        }
        
        firstPlayerTurn()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            
            self.currentState = PlayerGameState(player: self.activePlayer, gameViewControler: self,
                                                gameBoard: self.gameBoard,
                                                gameboardView: self.gameboardView,
                                           markViewPrototype: self.activePlayer.markViewPrototype)
            
            self.currentState.addSign(at: position)
            
            self.addStatesCommand(state: FivesGameCommand(position: position, markViewPrototype: self.activePlayer.markViewPrototype))
        }
    }
    
    func addStatesCommand(state: FivesGameCommand) {
        states.append(state)
        execute()
    }
    
    func execute() {
        guard states.count >= bufferStates else { return }
        
        if states.count == bufferStates {
            gameboardView.clear()
            nextPlayerTurn()
        }
        
        activePlayer = .second
                
        if states.count == bufferStates * 2 {
            gameboardView.clear()
            gameBoard.clear()
            
            firstPlayerTurn()
            
            gameboardView.onSelectPosition = nil
            viewStepsGame()
        }
    }
    
    func viewStepsGame() {
        var steps: [FivesGameCommand] = []
        for index in 0..<5 {
            steps.append(states[index])
            steps.append(states[5 + index])
        }
                
        steps.forEach { step in
            sleep(1)
            self.currentState.addSign(at: step.position)
            if self.currentState.isMoveCompleted {
                print(step.position)
                self.nextPlayerTurn()
            }
        }
        
        // Остановился вот тут, рисует но не перерисовывает
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
        
        Logger.shared.log(action: .restartGame)
    }
}

