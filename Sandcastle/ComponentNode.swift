//
//  ComponentNode.swift
//  Sandcastle
//
//  Created by Andrew Jiang on 2/18/17.
//  Copyright © 2017 Andrew Jiang. All rights reserved.
//

import SpriteKit

/**
 Every component of an electrical circuit should inherit
 from this class. Every component is also functionally
 a "resistor", but some can have resistance = 0, which
 means the electricity is "flowing"
 */
public class ComponentNode : SKSpriteNode {
    
    /**
     Arrays of wires connected to this component
     */
    var wires: [WireComponent] = []
    var resistance: Int = 0 // Ohms
    var volts: [Double] = [] // Colombs
    
    
    /**
     Limits the number of wires in the array
     -1 means unlimited
     */
    var maxWires: Int = -1
    
    public init() {
        super.init(
            texture: SKTexture(image:#imageLiteral(resourceName: "Spaceship")),
            color: UIColor.black,
            size: CGSize(width: 100, height: 100))
    }
    
    required public init?(coder aDecoder: NSCoder) { // serialization
        fatalError("init(coder:) has not been implemented")
    }
//
    /**
     Connects (self) node with another node by creating
     a new wire and setting the connections. Won't create
     connection if one already exists
     */
    func connectWith(node: ComponentNode) -> WireComponent? {
        // check if connection with wire already exists
        for wire in wires {
            if (wire.nodes.index(of: node) != nil) {
                return wire // connection already exists
            }
        }
        
        // create a new wire between the nodes
        let newWire: WireComponent = WireComponent()
        if (addWire(wire: newWire) && newWire.addNode(node: self) && newWire.addNode(node: node)) {
            return newWire
        }
        
        // unable to connect
        return nil
    }
    
    /**
     Adds a wire to the wires set
     @returns true if append successful, false otherwise
     */
    func addWire(wire: WireComponent) -> Bool {
        // if positiveWires does not contain wire and within limit, append
        if (!wires.contains(where: { (existingWire) -> Bool in
            return wire.equals(otherWire: existingWire)
        }) && (maxWires == -1 || wires.count <= maxWires)) {
            wires.append(wire)
            return true
        }
        return false
    }
    
    /**
     Removes a wire from the wires set
     @returns true if remove successful, false otherwise
     */
    func removeWire(wire: WireComponent) -> Bool {
        let indexOfWire: Int? = (wires.index { (existingWire) -> Bool in
            return wire.equals(otherWire: existingWire)
        })
        
        if (indexOfWire != nil) {
            wires.remove(at: indexOfWire!)
            return true
        }
        return false
    }
    
    /**
     Replace all wires with a single wire
     */
    func setWire(wire: WireComponent) -> Bool {
        if (maxWires == 0) {
            return false
        }
        clearWires()
        self.wires = [wire]
        return true
    }
    
    /**
     Replace all wires with a set of new wires
     While checking if this action is valid
     */
    func setWires(wires: [WireComponent]) -> Bool {
        if (maxWires != -1 && maxWires < wires.count) {
            return false
        }
        clearWires()
        self.wires = wires
        return true
    }
    
    /**
     Get the difference between voltages of connected wires
     */
    func getVoltageDiff(from: WireComponent, to: WireComponent) -> Double? {
        let fromIndex: Int? = wires.index { (wire: WireComponent) -> Bool in
            return wire.equals(otherWire: from)
        }
        let toIndex: Int? = wires.index { (wire: WireComponent) -> Bool in
            return wire.equals(otherWire: to)
        }
        
        // check if the indexes exist
        if (fromIndex == nil || toIndex == nil) {
            return nil
        }
        
        // check if volts exists in the indexes
        if (fromIndex! < volts.count && toIndex! < volts.count) {
            return volts[fromIndex!] - volts[toIndex!]
        }

        return nil // fallback
    }
    
    func clearWires() -> () {
        wires.removeAll()
    }
    
}
