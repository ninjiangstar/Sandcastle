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
        let lightTexture: SKTexture = SKTexture(image: #imageLiteral(resourceName: "bulb-inactive"))
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
    
    override func getElement() -> Element? {
        // todo: check terminals
        return self.resistor
    }
    
    override func getTerminalPosition(wire: Wire) -> CGPoint {
        if (wireTerminals.count == 0 || wireTerminals.index(of: wire) == 0) {
            return CGPoint(x: self.position.x - (self.frame.width / 4), y: self.position.y - (self.frame.height / 2))
        } else if (wireTerminals.count == 1 || wireTerminals.index(of: wire) == 1) {
            return CGPoint(x: self.position.x + (self.frame.width / 4), y: self.position.y - (self.frame.height / 2))
        }
        return super.getTerminalPosition(wire: wire)
    }
    
}
