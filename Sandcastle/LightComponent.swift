//
//  LightComponent.swift
//  Sandcastle
//
//  Created by Andrew Jiang on 2/19/17.
//  Copyright © 2017 Andrew Jiang. All rights reserved.
//

import SpriteKit

public class LightComponent : Component {
    
    var resistor: ResistanceElement?
    var circuit: Circuit?
    
    init(circuit: Circuit, resistance: Double) {
        super.init()
        self.circuit = circuit
        self.resistor = circuit.addResistanceElement(resistance: resistance)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
