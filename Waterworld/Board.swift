//
//  Board.swift
//  Waterworld
//
//  Created by Vladimir Kavlakan on 2/6/18.
//  Copyright © 2018 Vladimir Kavlakan. All rights reserved.
//

import Foundation

final class Board {
    
    var numberOfCells: Int {
        return size.height * size.width
    }
    
    var size: Size
    var cells: [[Cell]]
    
    // fast access
    var _cells: [String: Cell] = [:]
    
    // MARK: init
    init(size: Size = Size.default) {
        self.size = size
        self.cells = []
        for x in 0..<size.width {
            var column: [Cell] = []
            for y in 0..<size.height {
                column.append(Cell(position: Position(x, y)))
            }
            cells.append(column)
        }
    }
    
    // MARK: Public
    func contains(_ inhabitant: Inhabitant) -> Bool {
        return _cells[inhabitant.uuid] != nil
    }
    func inhabitant(at index: Int) -> Inhabitant? {
        let x = index % size.width
        let y = index / size.width
        return cells[x][y].inhabitant
    }
    
    func setInhabitantAtRandomPosition(_ inhabitant: Inhabitant) -> Bool {
        guard let position = availablePosition else {
            return false
        }
        cells[position.x][position.y].inhabitant = inhabitant
        _cells[inhabitant.uuid] = cells[position.x][position.y]
        return true
    }
    
    @discardableResult
    func setInhabitant(_ inhabitant: Inhabitant, near anchorInhabitant: Inhabitant) -> Bool {
        guard let cell = _cells[anchorInhabitant.uuid] else { return false }
        let emptyNearbyCells = getNearbyCells(for: cell).filter({ $0.inhabitant == nil })
        guard emptyNearbyCells.isEmpty == false else { return false }
        let index = Int(arc4random_uniform(UInt32(emptyNearbyCells.count)))
        let targetCell = emptyNearbyCells[index]
        targetCell.inhabitant = inhabitant
        _cells[inhabitant.uuid] = targetCell
        return true
    }
    
    @discardableResult
    func move(_ inhabitant: Inhabitant) -> Bool {
        guard let cell = _cells[inhabitant.uuid] else { return false }
        let emptyNearbyCells = getNearbyCells(for: cell).filter({ $0.inhabitant == nil })
        guard emptyNearbyCells.isEmpty == false else { return false }
        let index = Int(arc4random_uniform(UInt32(emptyNearbyCells.count)))
        let targetCell = emptyNearbyCells[index]
        targetCell.inhabitant = inhabitant
        cell.inhabitant = nil
        _cells[inhabitant.uuid] = targetCell
        return true
    }
    
    @discardableResult
    func move(_ inhabitant: Inhabitant, into anotherInhabitant: Inhabitant) -> Bool {
        guard let fromCell = _cells[inhabitant.uuid], let targetCell = _cells[anotherInhabitant.uuid] else { return false }
        targetCell.inhabitant = inhabitant
        fromCell.inhabitant = nil
        _cells[anotherInhabitant.uuid] = nil
        _cells[inhabitant.uuid] = targetCell
        return true
    }
    
    @discardableResult
    func remove(_ inhabitant: Inhabitant) -> Bool {
        guard let cell = _cells[inhabitant.uuid] else { return false }
        cell.inhabitant = nil
        _cells[inhabitant.uuid] = nil
        return true
    }
    
    var inhabitantsForTurn: [Inhabitant] {
        var result: [Inhabitant] = []
        for y in 0..<size.height {
            for x in 0..<size.width {
                if let inhabitant = cells[x][y].inhabitant {
                    result.append(inhabitant)
                }
            }
        }
        return result
    }
    
    func inhabitants(near inhabitant: Inhabitant) -> [Inhabitant] {
        guard let cell = _cells[inhabitant.uuid] else { return [] }
        let nearbyCells = getNearbyCells(for: cell)
        return nearbyCells.flatMap({ $0.inhabitant })
    }
    
    func set(_ inhabitant: Inhabitant, near anchorInhabitant: Inhabitant) -> Bool {
        guard let anchor = _cells[anchorInhabitant.uuid] else { return false }
        let nearbyCells = getNearbyCells(for: anchor).filter({ $0.isEmpty })
        guard nearbyCells.isEmpty == false else { return false }
        let targetCell = nearbyCells[Int(arc4random_uniform(UInt32(nearbyCells.count)))]
        
        if let _oldInhabitant = targetCell.inhabitant {
            _cells[_oldInhabitant.uuid] = nil
        }
        targetCell.inhabitant = inhabitant
        _cells[inhabitant.uuid] = targetCell
        return true
    }
    
    // MARK: Private
    fileprivate var availablePosition: Position? {
        var pool: [Position] = []
        for x in 0..<size.width {
            for y in 0..<size.height {
                if cells[x][y].inhabitant == nil {
                    pool.append(Position(x, y))
                }
            }
        }
        guard pool.isEmpty == false else { return nil }
        let randomIndex = Int(arc4random_uniform(UInt32(pool.count)))
        return pool[randomIndex]
    }
    
    fileprivate func positionIsValid(_ position: Position) -> Bool {
        return position.x >= 0 && position.x < size.width && position.y >= 0 && position.y < size.height
    }
    
    fileprivate func getNearbyCells(for cell: Cell) -> [Cell] {
        let position = cell.position
        var positions: [Position] = []
        for x in (position.x - 1)...(position.x + 1) {
            for y in (position.y - 1)...(position.y + 1) {
                if x == position.x && y == position.y {
                    continue
                }
                let _position = Position(x, y)
                if positionIsValid(_position) {
                    positions.append(_position)
                }
            }
        }
        return positions.map({ cells[$0.x][$0.y] })
    }
}
