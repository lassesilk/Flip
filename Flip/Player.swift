//
//  Player.swift
//  Flip
//
//  Created by Lasse Silkoset on 25/05/2020.
//  Copyright © 2020 Lasse Silkoset. All rights reserved.
//

import UIKit
import GameplayKit

class Player: NSObject, GKGameModelPlayer {
    
    var playerId: Int
    
    static let allPlayers = [Player(stone: .black), Player(stone: .white)]
    
    var stoneColor: StoneColor
    
    init(stone: StoneColor) {
        stoneColor = stone
        self.playerId = stone.rawValue
    }
    
    var opponent: Player {
        
        if stoneColor == .black {
            return Player.allPlayers[1]
        } else {
            return Player.allPlayers[0]
        }
    }
}
