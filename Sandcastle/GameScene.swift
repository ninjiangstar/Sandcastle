//
//  GameScene.swift
//  Sandcastle
//
//  Created by Andrew Jiang on 2/18/17.
//  Copyright © 2017 Andrew Jiang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var circuit: Circuit = Circuit()

    var selectedNode: Component?
    var isDraggable = false // means create wires instead!
    var startingLoc: CGPoint?
    var activeWire: Wire?
    var wires: [Wire] = []
    
    
    var gridSpace: Double = 40.0
    var components: [Component] = []
    var runs: Int = 0 // don't run sceneDidLoad twice
    
    
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        self.backgroundColor = UIColor.clear
        
        if runs == 0 {
            populateCircuit()
        }
        runs += 1
    }
    
    // runs only once; essentially the same as "viewDidAppear"
    override func didMove(to view: SKView) {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        longPressRecognizer.minimumPressDuration = 0.3
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlesGesture(recognizer:)))
        self.view!.addGestureRecognizer(longPressRecognizer)
        self.view!.addGestureRecognizer(gestureRecognizer)
    }
    
    func populateCircuit() {
        // battery
        let battery: Component = BatteryComponent(circuit: circuit, voltage: 5)
        battery.position.x = (-self.frame.size.width * 3) / 5 / 1.75
        battery.position.y = -self.frame.size.height / 4.5 - 50
        self.addChild(battery)
        self.components.append(battery)
        
        // resistors
        let resistor1: Component = ResistorComponent(circuit: circuit, resistance: 1000)
        resistor1.position.x = (self.frame.size.width * 3) / 5 / 1.75
        resistor1.position.y = -self.frame.size.height / 4.5 + 50
        let resistor2: Component = ResistorComponent(circuit: circuit, resistance: 2500)
        resistor2.position.x = self.frame.size.width / 5 / 1.75
        resistor2.position.y = -self.frame.size.height / 4.5 - 50
        let resistor3: Component = ResistorComponent(circuit: circuit, resistance: 5000)
        resistor3.position.x = -self.frame.size.width / 5 / 1.75
        resistor3.position.y = -self.frame.size.height / 4.5 + 50
        self.addChild(resistor1)
        self.addChild(resistor2)
        self.addChild(resistor3)
        self.components.append(resistor1)
        self.components.append(resistor2)
        self.components.append(resistor3)
        
        // lightbulb
        let lightbulb: Component = LightComponent(circuit: circuit, resistance: 2500)
        lightbulb.position.y = self.frame.size.width / 5
        self.addChild(lightbulb)
        self.components.append(lightbulb)
    }
    
    func startWire(from: Component) {
        activeWire = Wire(circuit: circuit, start: from)
        self.addChild(activeWire!)
    }
    
    func moveWire(to: CGPoint) {
        activeWire?.movePoint(point: to)
    }
    
    func endWire() {
        activeWire?.path = nil
        activeWire = nil
    }
    
    func connectWire(to: Component) {
        activeWire?.connect(to: to)
        if (activeWire != nil) {
            wires.append(activeWire!)
        }
    }
    
    // called by gesture recognizer
    func handlesGesture(recognizer: UIPanGestureRecognizer) {
        var touchLocation = recognizer.location(in: recognizer.view)
        touchLocation = self.convertPoint(fromView: touchLocation)
        var touchedNodes = self.nodes(at: touchLocation)
        touchedNodes = touchedNodes.filter { touchedNode -> Bool in return touchedNode is Component }
        let touchedNode: Component? = touchedNodes.first as! Component?
        
        
        switch (recognizer.state) {
        case .began:
            self.onGestureBegan(touchLocation: touchLocation, node: touchedNode)
            break
        case .changed:
            self.onGestureChanged(touchLocation: touchLocation, node: selectedNode)
            break
        case .ended:
            self.onGestureEnded(touchLocation: touchLocation, node: touchedNode)
            break
        default: break
        }
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        var touchLocation = recognizer.location(in: recognizer.view)
        touchLocation = self.convertPoint(fromView: touchLocation)
        var touchedNodes = self.nodes(at: touchLocation)
        touchedNodes = touchedNodes.filter { touchedNode -> Bool in return touchedNode is Component }
        let touchedNode: Component? = touchedNodes.first as! Component?
        
        switch (recognizer.state) {
        case .began:
            self.onLongPressBegan(touchLocation: touchLocation, node: touchedNode)
            break
        case .changed:
            self.onLongPressChanged(touchLocation: touchLocation, node: selectedNode)
        case .ended:
            self.onLongPressEnded(touchLocation: touchLocation, node: selectedNode)
            break
        default: break
        }
    }
    
    func onReaderBegan(touchLocation: CGPoint, node: Component?) {
        // select node and reorder zPositioning
        startingLoc = touchLocation
        selectedNode = node
        node?.removeAllActions()
        bringComponentToFront(component: selectedNode)
    }
    
    func onGestureBegan(touchLocation: CGPoint, node: Component?) {
        onReaderBegan(touchLocation: touchLocation, node: node)
        if (node != nil) {
            startWire(from: node!)
        }
    }
    
    func onGestureChanged(touchLocation: CGPoint, node: Component?) {
        // set wire drag
        moveWire(to: touchLocation)
    }
    
    func onGestureEnded(touchLocation: CGPoint, node: Component?) {
        // connect wire
        if (node != nil) {
            connectWire(to: node!)
        } else {
            endWire()
        }
    }
    
    func onLongPressBegan(touchLocation: CGPoint, node: Component?) {
        self.onReaderBegan(touchLocation: touchLocation, node: node)
        if (node != nil) {
            node!.run(SKAction.scale(to: 1.2, duration: 0.1))
            let rotateLeft = SKAction.rotate(toAngle: CGFloat(M_PI/24), duration: 0.3)
            let rotateRight = SKAction.rotate(toAngle: CGFloat(-M_PI/24), duration: 0.3)
            node!.run(SKAction.repeatForever(SKAction.sequence([rotateLeft, rotateRight])))
        }
    }
    
    func onLongPressChanged(touchLocation: CGPoint, node: Component?) {
        moveComponent(to: touchLocation, node: node)
        if (node != nil) {
            node!.updateWires()
        }
    }
    
    func onLongPressEnded(touchLocation: CGPoint, node: Component?) {
        snapComponentAround(touchLocation: touchLocation, node: node)
        if (node != nil) {
            let scale: SKAction = SKAction.scale(to: 1, duration: 0.1)
            let rotate: SKAction = SKAction.rotate(toAngle: CGFloat(0), duration: 0.1)
            let next: SKAction = SKAction.run {
                node!.updateWires()
            }
            node!.run(SKAction.sequence([scale, rotate, next]))
        }
    }
    
    func moveComponent(to: CGPoint, node: Component?) {
        if (node != nil) {
            let move: SKAction = SKAction.move(to: to, duration: 0.1)
            node!.run(move)
        }
    }
    
    func snapComponentAround(touchLocation: CGPoint, node: Component?) {
        if (node != nil) {
            node!.removeAllActions()
            self.moveComponent(to: CGPoint(
                x: round(Double(touchLocation.x) / gridSpace) * gridSpace,
                y: round(Double(touchLocation.y) / gridSpace) * gridSpace), node: node)
        }
    }
    
    func bringComponentToFront(component: Component?) {
        if (component != nil) {
            let index = components.index(of: component!)
            components.remove(at: index!)
            components.insert(component!, at: 0)
            refreshZIndexOrder()
        }
    }
    
    func refreshZIndexOrder() {
        for i in 0..<components.count {
            components[i].zPosition = CGFloat(components.count - i)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
