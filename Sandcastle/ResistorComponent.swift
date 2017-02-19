//
//  ResistorComponent.swift
//  Sandcastle
//
//  Created by Andrew Jiang on 2/19/17.
//  Copyright © 2017 Andrew Jiang. All rights reserved.
//

import SpriteKit

public class ResistorComponent : Component {
  
    var resistor: ResistanceElement?
    var circuit: Circuit?
    
    init(circuit: Circuit, resistance: Double) {
        var texture: SKTexture = SKTexture(image: #imageLiteral(resourceName: "small-r"))
        var size: CGSize = CGSize(width: 312/2, height: 74/2)
        
        if (resistance == 1000) {
            texture = SKTexture(image: #imageLiteral(resourceName: "small-r"))
            size = CGSize(width: 312/2, height: 74/2)
        } else if (resistance == 2500) {
            texture = SKTexture(image: #imageLiteral(resourceName: "medium-r"))
            size = CGSize(width: 312/2, height: 82/2)
        } else if (resistance == 5000) {
            texture = SKTexture(image: #imageLiteral(resourceName: "large-r"))
            size = CGSize(width: 312/2, height: 96/2)
        }
        
        super.init(texture: texture, size: size)
        
        self.circuit = circuit
        self.resistor = circuit.addResistanceElement(resistance: resistance)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getElement() -> Element? {
        // todo: check terminals
        return self.resistor
    }
    
    override func getTerminalPosition(wire: Wire) -> CGPoint {
        if (wireTerminals.count == 0 || wireTerminals.index(of: wire) == 0) {
            return CGPoint(x: self.position.x - (self.frame.width / 2), y: self.position.y - (self.frame.height / 4) + 5)
        } else if (wireTerminals.count == 1 || wireTerminals.index(of: wire) == 1) {
            return CGPoint(x: self.position.x + (self.frame.width / 2), y: self.position.y - (self.frame.height / 4) + 5)
        }
        return super.getTerminalPosition(wire: wire)
    }
    
}
