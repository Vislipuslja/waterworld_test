//
//  Game.swift
//  Waterworld
//
//  Created by Vladimir Kavlakan on 2/6/18.
//  Copyright © 2018 Vladimir Kavlakan. All rights reserved.
//

import Foundation

protocol GameDelegate: AnyObject {
    func gameRestarted(_ game: Game)
    func gameDidTurn(_ game: Game)
    func gameEnded(_ game: Game)
}

final class Game {
    
    var reproductionCycleDurationForPenguins: Int = 3
    var reproductionCycleDurationForOrcas: Int = 8
    var starvingCycleDurationForOrcas: Int = 3
    
    weak var delegate: GameDelegate?
    var board: Board!
    
    var penguins: [Penguin] = [] {
        didSet {
//            print(penguins.count)
        }
    }
    var orcas: [Orca] = []
    
    // MARK: init
    init() {
        restart()
    }
    
    // MARK: Public
    func restart() {
        penguins = []
        orcas = []
        board = Board()
        
        // creating penguins
        let penguinsCount = board.numberOfCells / 2
        (0..<penguinsCount).forEach { _ in
            let penguin = createPenguin()
            setOnBoard(penguin)
            penguins.append(penguin)
        }
        
        // creating orcas
        let orcasCount = board.numberOfCells / 20
        (0..<orcasCount).forEach({ _ in
            let orca = createOrca()
            setOnBoard(orca)
            orcas.append(orca)
        })
        
        delegate?.gameRestarted(self)
    }
    
    func makeTurn() {
        guard gameIsEnded == false else {
            restart()
            return
        }
        board.inhabitantsForTurn.forEach({ inhabitant in
            guard board.contains(inhabitant) else { return }
            inhabitant.makeTurn()
        })
        guard gameIsEnded else {
            delegate?.gameDidTurn(self)
            return
        }
        delegate?.gameDidTurn(self)
        delegate?.gameEnded(self)

    }
    
    // MARK: Private
    fileprivate func createPenguin() -> Penguin {
        let penguin = Penguin(reproductionCycleDuration: reproductionCycleDurationForPenguins)
        penguin.delegate = self
        return penguin
    }
    
    fileprivate func createOrca() -> Orca {
        let orca = Orca(reproductionCycleDuration: reproductionCycleDurationForOrcas,
                        starvingCycleDuration: starvingCycleDurationForOrcas)
        orca.delegate = self
        return orca
    }
    
    fileprivate func setOnBoard(_ inhabitant: Inhabitant) {
        guard board.setInhabitantAtRandomPosition(inhabitant) else {
            fatalError("no space for new inhabitants")
        }
    }
    
    fileprivate var gameIsEnded: Bool {
        return (orcas.isEmpty && penguins.isEmpty) || penguins.count == board.numberOfCells
    }
}



// MARK: - Penguin delegate
extension Game: PenguinDelegate {
    func reproduce(_ penguin: Penguin) -> Bool {
        let child = createPenguin()
        guard board.set(child, near: penguin) else { return false }
        penguins.append(child)
       return true
    }
    
    func move(_ penguin: Penguin) -> Bool {
        return board.move(penguin)
    }
}



// MARK: - Orca delegate
extension Game: OrcaDelegate {
    
    func reproduce(_ orca: Orca) -> Bool {
        let child = createOrca()
        guard board.set(child, near: orca) else {
            return false
        }
        orcas.append(child)
        return true
    }
    
    func eat(_ orca: Orca) -> Bool {
        let nearbyInhabitants = board.inhabitants(near: orca)
        guard nearbyInhabitants.isEmpty == false else { return false }
        let eatableNearbyInhabitants = nearbyInhabitants.filter({ $0 is Penguin })
        guard eatableNearbyInhabitants.isEmpty == false else { return false }
        let index = Int(arc4random_uniform(UInt32(eatableNearbyInhabitants.count)))
        let food = eatableNearbyInhabitants[index]
        guard board.move(orca, into: food) else { return false }
        penguins = penguins.filter({ $0 !== food })
        return true
    }
    
    func move(_ orca: Orca) -> Bool {
        return board.move(orca)
    }
    
    func die(_ orca: Orca) -> Bool {
        orcas = orcas.filter({ $0 !== orca })
        return board.remove(orca)
    }
    
}
