//
//  WireComponent.swift
//  Sandcastle
//
//  Created by Andrew Jiang on 2/18/17.
//  Copyright © 2017 Andrew Jiang. All rights reserved.
//

import Foundation

/**
 A WireComponent represents a "wired" connection between any
 two ComponentNodes. In a connected circuit, each wire will allow
 electricity to be transferred from node to node, but its current
 and direction will be determined via the system as a whole.
 */
public class WireComponent {
    
    // always make sure there is only 2 elements in the node
    var nodes: [ComponentNode] = []
    
    
    public init() {
        // do something
    }
    
    /**
     Check if this wire is equal to another wire
     */
    func equals(otherWire: WireComponent) -> Bool {
        return self.nodes.elementsEqual(otherWire.nodes)
    }
    
    /**
     add node to the "set"
     ensures that node count is <= 2
     */
    func addNode(node: ComponentNode) -> Bool {
        // if positiveWires does not contain wire and within limit, append
        if (!nodes.contains(node) && (nodes.count < 2)) {
            nodes.append(node)
            return true
        }
        return false
    }
    
    /**
     remove node from the "set"
     */
    func removeNode(node: ComponentNode) -> Bool {
        let indexOfNode: Int? = nodes.index(of: node)
        if (indexOfNode != nil) {
            nodes.remove(at: indexOfNode!)
            return true
        }
        return false
    }
    
    func replaceNode(findNode: ComponentNode, replaceWith: ComponentNode) -> Bool {
        return removeNode(node: findNode) && addNode(node: replaceWith)
    }
    
    /**
     allows for traversing nodes by returning the destination
     ComponentNode of the other end of the wire
     */
    func traverse(fromNode: ComponentNode) -> ComponentNode? {
        let indexOfNode: Int? = nodes.index(of: fromNode)
        if (indexOfNode != nil && nodes.count == 2) {
            return nodes[1 - indexOfNode!]
        }
        return nil
    }
    
}
