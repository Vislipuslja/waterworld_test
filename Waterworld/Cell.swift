//
//  Cell.swift
//  Waterworld
//
//  Created by Vladimir Kavlakan on 2/6/18.
//  Copyright © 2018 Vladimir Kavlakan. All rights reserved.
//

import Foundation

final class Cell {
    
    var inhabitant: Inhabitant?
    let position: Position
    
    var isEmpty: Bool {
        return inhabitant == nil
    }
    
    // MARK: init
    init(position: Position) {
        self.position = position
    }
}
