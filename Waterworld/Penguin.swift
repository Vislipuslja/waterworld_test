//
//  Penguin.swift
//  Waterworld
//
//  Created by Vladimir Kavlakan on 2/6/18.
//  Copyright © 2018 Vladimir Kavlakan. All rights reserved.
//

import UIKit

protocol PenguinDelegate: AnyObject {
    @discardableResult
    func reproduce(_ penguin: Penguin) -> Bool
    @discardableResult
    func move(_ penguin: Penguin) -> Bool
}

final class Penguin: Inhabitant {
    
    weak var delegate: PenguinDelegate!
    var reproductionCycleDuration: Int
    
    // MARK: init
    init(reproductionCycleDuration: Int) {
        self.reproductionCycleDuration = reproductionCycleDuration
        self.turnsToReproduction = reproductionCycleDuration
    }
    
    // MARK: Inhabitant
    var uuid: String = UUID().uuidString
    var turnsToReproduction: Int
    var image: UIImage {
        return #imageLiteral(resourceName: "penguin_image")
    }
    
    
    func makeTurn() {
        turnsToReproduction -= 1
        guard turnsToReproduction > 0 else {
            delegate.reproduce(self)
            turnsToReproduction = 3
            return
        }
        delegate.move(self)
    }
    
}
