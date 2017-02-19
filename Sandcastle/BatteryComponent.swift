//
//  BatteryComponent.swift
//  Sandcastle
//
//  Created by Andrew Jiang on 2/19/17.
//  Copyright © 2017 Andrew Jiang. All rights reserved.
//

import SpriteKit

public class BatteryComponent : Component {
    
    var battery: (source: VoltageElement, ground: GroundElement, edge: (from: Element, to: Element))?
    var circuit: Circuit?
    
    init(circuit: Circuit, voltage: Double) {
        super.init(texture: SKTexture(image: #imageLiteral(resourceName: "battery")), size: CGSize(width: 57, height: 85))
        self.circuit = circuit
        self.battery = circuit.addBatteryElement(voltage: voltage)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
