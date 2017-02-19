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
        var lightTexture: SKTexture = SKTexture(image: #imageLiteral(resourceName: "bulb-inactive"))
        super.init(texture: lightTexture, size: CGSize(width: 214/2, height: 302/2))
        self.circuit = circuit
        self.resistor = circuit.addResistanceElement(resistance: resistance)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func turnOn() {
        self.texture = SKTexture(image: #imageLiteral(resourceName: "bulb-active"))
    }
    
    func turnOff() {
        self.texture = SKTexture(image: #imageLiteral(resourceName: "bulb-inactive"))
    }
    
    func turnBroken() {
        self.texture = SKTexture(image: #imageLiteral(resourceName: "bulb-broken"))
    }
    
}
