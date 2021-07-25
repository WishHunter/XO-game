//
//  LogInvoker.swift
//  XO-game
//
//  Created by Veaceslav Chirita on 19.07.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class LogInvoker {
    public static let shared = LogInvoker()
    
    private let receiver = LogReceiver()
    private var commands: [LogCommand] = []
    private let bufferSize = 5
    
    private init() {}
    
    func addLogCommand(command: LogCommand) {
        commands.append(command)
        execute()
    }
    
    private func execute() {
        guard commands.count >= bufferSize else { return }
        
        commands.forEach { receiver.sendMessage(message: $0.logMessage) }
        commands = []
    }
}
