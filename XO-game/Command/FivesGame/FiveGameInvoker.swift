//
//  FiveGameInvoker.swift
//  XO-game
//
//  Created by d.molkov on 26.07.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class FiveGameInvoker {
    public var states: [FivesGameCommand] = []
    public let bufferStates = 5
    
    func addStatesCommand(state: FivesGameCommand) {
        states.append(state)
    }
    
    func clear() {
        states = []
    }
}
