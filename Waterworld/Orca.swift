//
//  Orca.swift
//  Waterworld
//
//  Created by Vladimir Kavlakan on 2/6/18.
//  Copyright © 2018 Vladimir Kavlakan. All rights reserved.
//

import UIKit

protocol OrcaDelegate: AnyObject {
    @discardableResult
    func reproduce(_ orca: Orca) -> Bool
    @discardableResult
    func eat(_ orca: Orca) -> Bool
    @discardableResult
    func move(_ orca: Orca) -> Bool
    @discardableResult
    func die(_ orca: Orca) -> Bool
}

final class Orca: Inhabitant {
    
    weak var delegate: OrcaDelegate!
    var reproductionCycleDuration: Int
    var starvingCycleDuration: Int
    
    // MARK: init
    init(reproductionCycleDuration: Int, starvingCycleDuration: Int) {
        self.reproductionCycleDuration = reproductionCycleDuration
        self.starvingCycleDuration = starvingCycleDuration
        self.turnsToReproduction = reproductionCycleDuration
        self.turnsToDeath = starvingCycleDuration
    }
    
    
    // MARK: Inhabitantb
    var uuid: String = UUID().uuidString
    var turnsToReproduction: Int
    var turnsToDeath: Int
    var image: UIImage {
        return #imageLiteral(resourceName: "orca_image")
    }
    
    func makeTurn() {
        turnsToDeath -= 1
        guard turnsToDeath > 0 else {
            guard delegate.eat(self) else {
                delegate.die(self)
                return
            }
            turnsToDeath = starvingCycleDuration
            return
        }
        turnsToReproduction -= 1
        guard turnsToReproduction > 0 else {
            delegate.reproduce(self)
            turnsToReproduction = reproductionCycleDuration
            return
        }
        guard delegate.eat(self) else {
            delegate.move(self)
            return
        }
        turnsToDeath = starvingCycleDuration
    }
    
}
