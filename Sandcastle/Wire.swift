//
//  Wire.swift
//  Sandcastle
//
//  Created by Andrew Jiang on 2/19/17.
//  Copyright © 2017 Andrew Jiang. All rights reserved.
//

import SpriteKit

public class Wire : SKShapeNode {
    
    var edge: (from: Element, to: Element)?
    var circuit: Circuit?
    
    var from: Component?
    var to: Component?
    
    init(circuit: Circuit, start: Component) {
        super.init()
        self.circuit = circuit
        from = start
        
        self.strokeColor = UIColor(red: CGFloat(90.0/255.0), green: CGFloat(222.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.8))
        self.lineWidth = 10
        self.lineCap = CGLineCap.round
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getFromTerminal() -> CGPoint {
        return (from?.getTerminalPosition(wire: self))!
    }
    
    func getToTerminal() -> CGPoint {
        return (to?.getTerminalPosition(wire: self))!
    }
    
    func movePoint(point: CGPoint) {
        let fromPoint = getFromTerminal()
        let pathToDraw: CGMutablePath = CGMutablePath()
        pathToDraw.move(to: fromPoint)
        pathToDraw.addLine(to: point)
        self.path = pathToDraw
    }
    
    func drawConnectionPath() {
        movePoint(point: getToTerminal())
    }
    
    func connect(to: Component) {
        self.to = to
        
        edge = circuit!.createEdge(from: (from?.getElement())!, to: to.getElement()!)
        from?.addWire(wire: self)
        to.addWire(wire: self)
    }
}
