//
//  GameState.swift
//  XO-game
//
//  Created by Veaceslav Chirita on 19.07.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

protocol GameState: AnyObject {
    var isMoveCompleted: Bool { get }
    func addSign(at position: GameboardPosition)
    func begin()
}
