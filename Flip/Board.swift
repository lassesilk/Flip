//
//  Board.swift
//  Flip
//
//  Created by Lasse Silkoset on 25/05/2020.
//  Copyright © 2020 Lasse Silkoset. All rights reserved.
//

import UIKit
import GameplayKit

class Board: NSObject, GKGameModel {
    
    var players: [GKGameModelPlayer]? {
        return Player.allPlayers
    }
    
    var activePlayer: GKGameModelPlayer? {
        return currentplayer
    }
    
    var currentplayer = Player.allPlayers[0]
    
    static let size = 8
    
    static let moves = [Move(row: -1, col: -1), Move(row: 0, col: -1), Move(row: 1, col: -1), Move(row: -1, col: 0), Move(row: 1, col: 0), Move(row: -1, col: 1), Move(row: 0, col: 1), Move(row: 1, col: 1)]
    
    var rows = [[StoneColor]]()
    
    func canMoveIn(row: Int, col: Int) -> Bool {
        
        if !isInBounds(row: row, col: col) { return false }
        
        let stone = rows[row][col]
        if stone != .empty { return false }
        
        for move in Board.moves {
            
            var passedOpponent = false
            
            var currentRow = row
            var currentCol = col
            
            for _ in 0..<Board.size {
                
                currentRow += move.row
                currentCol += move.col
                
                guard isInBounds(row: currentRow, col: currentCol) else { break }
                
                let stone = rows[currentRow][currentCol]
                
                if (stone == currentplayer.opponent.stoneColor) {
                    
                    passedOpponent = true
                } else if stone == currentplayer.stoneColor && passedOpponent {
                    return true
                } else {
                    break
                }
            }
        }
        
        return false
    }
    
    func isInBounds(row: Int, col: Int) -> Bool {
        
        if row < 0 { return false }
        if col < 0 { return false }
        if row >= Board.size { return false }
        if col >= Board.size { return false }
        
        return true
    }
    
    func makeMove(player: Player, row: Int, col: Int) -> [Move] {
        var didCapture = [Move]()
        
        rows[row][col] = player.stoneColor
        
        didCapture.append(Move(row: row, col: col))
        
        for move in Board.moves {
            
            var mightCapture = [Move]()
            var currentRow = row
            var currentCol = col
            
            for _ in 0..<Board.size {
                
                currentRow += move.row
                currentCol += move.col
                
                guard isInBounds(row: currentRow, col: currentCol) else { break }
                
                let stone = rows[currentRow][currentCol]
                
                if stone == player.opponent.stoneColor {
                    
                    mightCapture.append(Move(row: currentRow, col: currentCol))
                } else if stone == player.stoneColor {
                    
                    didCapture.append(contentsOf: mightCapture)
                    
                    mightCapture.forEach {
                        rows[$0.row][$0.col] = player.stoneColor
                    }
                    
                    break
                } else {
                    break
                }
            }
        }
        return didCapture
    }
    
    
    func getScores() -> (black: Int, white: Int) {
        
        var black = 0
        var white = 0
        
        rows.forEach {
            
            $0.forEach {
                if $0 == .black {
                    black += 1
                } else if $0 == .white {
                    white += 1
                }
            }
        }
        
        return (black, white)
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        guard let playerObject = player as? Player else { return false }
        
        let scores = getScores()
        
        if playerObject.stoneColor == .black {
            return scores.black > scores.white + 10
        } else {
            return scores.white > scores.black + 10
        }
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        
        guard let playerObject = player as? Player else { return nil }
        
        if isWin(for: playerObject) || isWin(for: playerObject.opponent) {
            return nil
        }
        
        var moves = [Move]()
        
        for row in 0..<Board.size {
            for col in 0..<Board.size {
                if canMoveIn(row: row, col: col) {
                    moves.append(Move(row: row, col: col))
                }
            }
        }
        return moves
    }
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        guard let move = gameModelUpdate as? Move else { return }
        
        _ = makeMove(player: currentplayer, row: move.row, col: move.col)
        
        currentplayer = currentplayer.opponent
    }
    
    func setGameModel(_ gameModel: GKGameModel) {
        guard let board = gameModel as? Board else { return }
        
        currentplayer = board.currentplayer
        
        rows = board.rows
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Board()
        
        copy.setGameModel(self)
        
        return copy
    }
}
