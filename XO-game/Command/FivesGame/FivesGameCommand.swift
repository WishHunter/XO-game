//
//  FivesGameCommand.swift
//  XO-game
//
//  Created by Denis Molkov on 25.07.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class FivesGameCommand {
    let position: GameboardPosition
    let markViewPrototype: MarkView
    
    init(position: GameboardPosition, markViewPrototype: MarkView) {
        self.position = position
        self.markViewPrototype = markViewPrototype
    }
}
