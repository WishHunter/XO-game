//
//  TypeGameState.swift
//  XO-game
//
//  Created by Denis Molkov on 25.07.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

protocol TypeGameState: AnyObject {
    func firstPlayerTurn() -> GameState
    func nextPlayerTurn() -> GameState
}
