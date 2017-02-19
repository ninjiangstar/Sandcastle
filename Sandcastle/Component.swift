//
//  Component.swift
//  Sandcastle
//
//  Created by Andrew Jiang on 2/19/17.
//  Copyright © 2017 Andrew Jiang. All rights reserved.
//

import SpriteKit

public class Component : SKSpriteNode {
    public init() {
        super.init(
            texture: SKTexture(image:#imageLiteral(resourceName: "Spaceship")),
            color: UIColor.black,
            size: CGSize(width: 100, height: 100))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
