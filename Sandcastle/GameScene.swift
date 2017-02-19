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

    var selectedNodes: [SKSpriteNode] = []
    
    var gridSpace: Double = 40.0
    
//    var components: [ComponentNode] = []
    
    var runs: Int = 0
    
    func populateCircuit() {
        
        // create circuit
        let circuit: Circuit = Circuit()
        
        // battery
        let battery: Component = BatteryComponent(circuit: circuit, voltage: 5)
        battery.position.x = (-self.frame.size.width * 3) / 5 / 1.75
        battery.position.y = -self.frame.size.height / 4.5 - 50
        self.addChild(battery)
        
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
        
        // lightbulb
        let lightbulb: Component = LightComponent(circuit: circuit, resistance: 2500)
        lightbulb.position.y = self.frame.size.width / 5
        self.addChild(lightbulb)
        
    }
    
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
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        self.view!.addGestureRecognizer(gestureRecognizer)
    }
    
    // called by gesture recognizer
    func handlePan(recognizer: UIPanGestureRecognizer) {
        var touchLocation = recognizer.location(in: recognizer.view)
        touchLocation = self.convertPoint(fromView: touchLocation)
        switch (recognizer.state) {
        case .began:
            selectNodeForTouch(touchLocation: touchLocation)
            break
        case .changed:
            self.moveComponentsTo(touchLocation: touchLocation)
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
            break
        case .ended:
            // todo: velocity and momentum end
            self.snapComponentAround(touchLocation: touchLocation)
            break
        default: break
        }
    }
    
    func selectNodeForTouch(touchLocation: CGPoint) {
        var touchedNodes = self.nodes(at: touchLocation)
        
        touchedNodes = touchedNodes.filter { (touchedNode) -> Bool in
            return touchedNode is Component
        }
        
        for selectedNode in selectedNodes {
            if (!touchedNodes.contains(where: { (touchedNode) -> Bool in
                return selectedNode.isEqual(selectedNode)
            })) {
                selectedNode.removeAllActions()
            }
        }
        
        selectedNodes = touchedNodes as! [Component]
    }
    
    func moveComponentsTo(touchLocation: CGPoint) {
        for selectedNode in selectedNodes {
            // todo: gradual snap to middle
            
            if selectedNode is Component {
                selectedNode.position = touchLocation
            }
        }
    }
    
    func snapComponentAround(touchLocation: CGPoint) {
        for selectedNode in selectedNodes {
            if selectedNode is Component {
                selectedNode.position = CGPoint(
                    x: round(Double(touchLocation.x) / gridSpace) * gridSpace,
                    y: round(Double(touchLocation.y) / gridSpace) * gridSpace)
            }
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
