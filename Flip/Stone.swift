//
//  Stone.swift
//  Flip
//
//  Created by Lasse Silkoset on 25/05/2020.
//  Copyright © 2020 Lasse Silkoset. All rights reserved.
//

import SpriteKit
import UIKit

class Stone: SKSpriteNode {
    
    static let thinkingTexture = SKTexture(imageNamed: "thinking")
    static let whiteTexture = SKTexture(imageNamed: "white")
    static let blackTexture = SKTexture(imageNamed: "black")
    
    var row = 0
    var col = 0
    
    func setPlayer(_ player: StoneColor) {
        if player == .white {
            texture = Stone.whiteTexture
        } else if player == .black {
            texture = Stone.blackTexture
        } else if player == .choice {
            texture = Stone.thinkingTexture
        }
    }
    
}
