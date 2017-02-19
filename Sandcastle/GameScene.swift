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
    
    var gridSpace: Double = 20.0
    
    var components: [ComponentNode] = []
    
    override func sceneDidLoad() {

        self.backgroundColor = UIColor.white;
        
        self.lastUpdateTime = 0
        
        // add components
        let firstComponent: ComponentNode = ComponentNode()
        firstComponent.position = CGPoint(x: 0, y: 0)
        self.addChild(firstComponent)
        components.append(firstComponent)
    
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
            return touchedNode is ComponentNode
        }
        
        for selectedNode in selectedNodes {
            if (!touchedNodes.contains(where: { (touchedNode) -> Bool in
                return selectedNode.isEqual(selectedNode)
            })) {
                selectedNode.removeAllActions()
            }
        }
        
        selectedNodes = touchedNodes as! [ComponentNode]
    }
    
    func moveComponentsTo(touchLocation: CGPoint) {
        for selectedNode in selectedNodes {
            // todo: gradual snap to middle
            
            if selectedNode is ComponentNode {
                selectedNode.position = touchLocation
            }
        }
    }
    
    func snapComponentAround(touchLocation: CGPoint) {
        for selectedNode in selectedNodes {
            if selectedNode is ComponentNode {
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
