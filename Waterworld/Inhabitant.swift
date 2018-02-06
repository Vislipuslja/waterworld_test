//
//  Inhabitant.swift
//  Waterworld
//
//  Created by Vladimir Kavlakan on 2/6/18.
//  Copyright © 2018 Vladimir Kavlakan. All rights reserved.
//

import UIKit

protocol Inhabitant: AnyObject {
    var uuid: String {get}
    
    var image: UIImage {get}
    
    func makeTurn()
}
