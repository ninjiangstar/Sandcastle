//
//  ResistorComponent.swift
//  Sandcastle
//
//  Created by Andrew Jiang on 2/19/17.
//  Copyright © 2017 Andrew Jiang. All rights reserved.
//

import SpriteKit

public class ResistorComponent : Component {
  
    var resister: ResistanceElement?
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
        self.resister = circuit.addResistanceElement(resistance: resistance)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
