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
    
    override func getElement() -> Element? {
        // todo: check terminals
        return self.battery?.source
    }
    
    override func getTerminalPosition(wire: Wire) -> CGPoint {
        if (wireTerminals.count == 0 || wireTerminals.index(of: wire) == 0) {
            return CGPoint(x: self.position.x - (self.frame.width / 4), y: self.position.y + (self.frame.height / 2))
        } else if (wireTerminals.count == 1 || wireTerminals.index(of: wire) == 1) {
            return CGPoint(x: self.position.x + (self.frame.width / 4), y: self.position.y + (self.frame.height / 2))
        }
        return super.getTerminalPosition(wire: wire)
    }
    
}
