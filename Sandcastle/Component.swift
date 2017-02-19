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
            texture: SKTexture(image: UIImage.init()),
            color: UIColor.init(white: CGFloat(100), alpha: CGFloat(0)),
            size: CGSize(width: 100, height: 100))
    }
    
    public init(texture: SKTexture, size: CGSize) {
        super.init(
            texture: texture,
            color: UIColor.init(white: CGFloat(100), alpha: CGFloat(0)),
            size: size)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
