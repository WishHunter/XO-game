//
//  LogAction.swift
//  XO-game
//
//  Created by Veaceslav Chirita on 19.07.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

enum LogAction {
    case playerSetMarkView(player: Player, position: GameboardPosition)
    case gameFinished(winner: Player?)
    case restartGame
}
