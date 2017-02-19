//
//  CircuitContainer.swift
//  Sandcastle
//
//  Created by Andrew Jiang on 2/18/17.
//  Copyright © 2017 Andrew Jiang. All rights reserved.
//

import SpriteKit

public class CircuitContainer : SKShapeNode {
    
    var roots: [ComponentNode] = []
    var components: [ComponentNode] = []
    var wires: [WireComponent] = []
    
    init(size: CGSize, position: CGPoint) {
        super.init()
        let rect: CGRect = CGRect(origin: position, size: size)
        let cornerRadius: CGFloat = CGFloat(10)
//        super.init(rect: rect, cornerRadius: cornerRadius)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addRoot(battery: BatteryComponentNode) -> Bool {
        if (roots.index(of: battery) != nil) {
            return false
        }
        
        roots.append(battery)
        self.addChild(battery)
        return true
    }
    
    func addComponent(node: ComponentNode) -> Bool {
        if (components.index(of: node) != nil) {
            return false
        }
        
        components.append(node)
        self.addChild(node)
        return true
    }
    
    func wire(from: ComponentNode, to: ComponentNode) -> Bool {
        let newWire = from.connectWith(node: to)
        if (newWire != nil) {
            wires.append(newWire!)
            return true
        }
        return false
    }
}
