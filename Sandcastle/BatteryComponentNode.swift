//
//  BatteryComponentNode.swift
//  Sandcastle
//
//  Created by Andrew Jiang on 2/18/17.
//  Copyright © 2017 Andrew Jiang. All rights reserved.
//

import SpriteKit

/**
 This component should almost always act as the "root" to every circuit.
 */
public class BatteryComponentNode : ComponentNode {
    var source: VoltageComponentNode = VoltageComponentNode()
    var ground: GroundComponentNode = GroundComponentNode()
    
    func connectToSource(node: ComponentNode) -> Bool {
        return (self.connectWith(node: node) != nil) && (source.connectWith(node: node) != nil)
    }
    
    func removeFromSource(wire: WireComponent) -> Bool {
        return self.removeWire(wire: wire) && source.removeWire(wire: wire)
    }
    
    func connectToGround(node: ComponentNode) -> Bool {
        return (self.connectWith(node: node) != nil) && (ground.connectWith(node: node) != nil)
    }
    
    func removeFromGround(wire: WireComponent) -> Bool {
        return self.removeWire(wire: wire) && ground.removeWire(wire: wire)
    }
}
