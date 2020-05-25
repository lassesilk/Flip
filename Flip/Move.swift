//
//  Move.swift
//  Flip
//
//  Created by Lasse Silkoset on 25/05/2020.
//  Copyright © 2020 Lasse Silkoset. All rights reserved.
//

import UIKit
import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    
    var row: Int
    var col: Int
    
    var value = 0
    
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}
