//
//  SwitchComponent.swift
//  Sandcastle
//
//  Created by Andrew Jiang on 2/19/17.
//  Copyright © 2017 Andrew Jiang. All rights reserved.
//

import SpriteKit

public class SwitchComponent : Component {
    
    var circuit: Circuit?
    
    init(circuit: Circuit) {
        super.init()
        self.circuit = circuit
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
