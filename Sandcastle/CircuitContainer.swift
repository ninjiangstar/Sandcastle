////
////  CircuitContainer.swift
////  Sandcastle
////
////  Created by Andrew Jiang on 2/18/17.
////  Copyright © 2017 Andrew Jiang. All rights reserved.
////
//
//import SpriteKit
//
//public class CircuitContainer : SKNode {
//    
//    var roots: [ComponentNode] = []
//    var components: [ComponentNode] = []
//    var wires: [WireComponent] = []
//    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func addRoot(battery: BatteryComponentNode) -> Bool {
//        if (roots.index(of: battery) != nil) {
//            return false
//        }
//        
//        roots.append(battery)
//        self.addChild(battery)
//        return true
//    }
//    
//    func addComponent(node: ComponentNode) -> Bool {
//        if (components.index(of: node) != nil) {
//            return false
//        }
//        
//        components.append(node)
//        self.addChild(node)
//        return true
//    }
//    
//    func wire(from: ComponentNode, to: ComponentNode) -> Bool {
//        let newWire = from.connectWith(node: to)
//        if (newWire != nil) {
//            wires.append(newWire!)
//            return true
//        }
//        return false
//    }
//    
//    func generateCycles(root: ComponentNode) {
//        
//    }
//}
//
///*
// graph = [[1, 2], [1, 3], [1, 4], [2, 3], [3, 4], [2, 6], [4, 6], [8, 7], [8, 9], [9, 7]]
// cycles = []
// 
// def main():
// global graph
// global cycles
// for edge in graph:
// for node in edge:
// findNewCycles([node])
// for cy in cycles:
// path = [str(node) for node in cy]
// s = ",".join(path)
// print(s)
// 
// def findNewCycles(path):
// start_node = path[0]
// next_node= None
// sub = []
// 
// #visit each edge and each node of each edge
// for edge in graph:
// node1, node2 = edge
// if start_node in edge:
// if node1 == start_node:
// next_node = node2
// else:
// next_node = node1
// if not visited(next_node, path):
// # neighbor node not on path yet
// sub = [next_node]
// sub.extend(path)
// # explore extended path
// findNewCycles(sub);
// elif len(path) > 2  and next_node == path[-1]:
// # cycle found
// p = rotate_to_smallest(path);
// inv = invert(p)
// if isNew(p) and isNew(inv):
// cycles.append(p)
// 
// def invert(path):
// return rotate_to_smallest(path[::-1])
// 
// #  rotate cycle path such that it begins with the smallest node
// def rotate_to_smallest(path):
// n = path.index(min(path))
// return path[n:]+path[:n]
// 
// def isNew(path):
// return not path in cycles
// 
// def visited(node, path):
// return node in path
// 
// main()
// */
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
