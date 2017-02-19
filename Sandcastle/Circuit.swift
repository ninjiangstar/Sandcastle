//
//  Circuit.swift
//  Sandcastle
//
//  Created by Andrew Jiang on 2/18/17.
//  Copyright © 2017 Andrew Jiang. All rights reserved.
//

import Foundation

public class Circuit {
    
    init () {
//        print("FAK")
        // unit tests
        
        let battery1 = addBatteryElement(voltage: 1.5)
        let battery2 = addBatteryElement(voltage: 9.0)
        let resistor1 = addResistanceElement(resistance: 100.0)
        let resistor2 = addResistanceElement(resistance: 200.0)
        let junction1 = addJunctionElement()
        let junction2 = addJunctionElement()
        
        _ = createEdge(from: battery1.source, to: junction1)
        _ = createEdge(from: battery1.ground, to: junction2)
        _ = createEdge(from: junction1, to: resistor1)
        _ = createEdge(from: resistor1, to: junction2)
        _ = createEdge(from: junction2, to: resistor2)
        _ = createEdge(from: resistor2, to: battery2.ground)
        _ = createEdge(from: junction1, to: battery2.source)
        
        let junctionEdges = generateJunctionEdges()
        let kirchhoffsMatrix = generateKirchhoffsCurrentMatrix(junctionEdges: junctionEdges)
        kirchhoffsMatrix = generateKirchhoffsVoltageMatrix(currentMatrix: kirchhoffsMatrix)
        
    }
    
    // basic data
    var elements: [Element] = []
    var edges: [(from: Element, to: Element)] = []
    var negToPosEdges: [(from: Element, to: Element)] = []
    var roots: [(source: VoltageElement, ground: GroundElement, edge: (from: Element, to: Element))] = [] // batteries
    var junctions: [JunctionElement] = []
    
    func createEdge(from: Element, to: Element) -> (from: Element, to: Element) {
        // todo: check for limits
        let edge = (from: from, to: to)
        edges.append(edge)
        return edge
    }
    
    func createDirectionalEdge(from: Element, to: Element) -> (from: Element, to: Element) {
        // todo: check for limits
        negToPosEdges.append((from: from, to: to))
        return createEdge(from: from, to: to)
    }
    
    func addBatteryElement(voltage: Double) -> (source: VoltageElement, ground: GroundElement, edge: (from: Element, to: Element)) {
        let source: VoltageElement = VoltageElement(voltage: voltage)
        let ground: GroundElement =  GroundElement()
        let edge = createDirectionalEdge(from: ground, to: source)
        let battery = (source: source, ground: ground, edge: edge)
        
        // add to list of batteries
        roots.append(battery)
        
        // form directional edge
        return battery
    }
    
    func addJunctionElement() -> JunctionElement {
        let junctionElem: JunctionElement = JunctionElement()
        junctions.append(junctionElem)
        return junctionElem
    }
    
    func addResistanceElement(resistance: Double) -> ResistanceElement {
        let resistanceElem: ResistanceElement = ResistanceElement(resistance: resistance)
        elements.append(resistanceElem)
        return resistanceElem
    }
    
    
    /**
     The general strategy here is to loop through each JunctionElement and
     employ a DFS Iterative algorithm to generate a list of "element strings" connecting one junction to another
     */
    func generateJunctionEdges() -> [[Element]] {
        var junctionEdges: [[Element]] = [] // [[Junction, Element, ...., Element, Junction], ...]
        junctionEdges.removeAll()
    
        var visitedElements: [Element] = []
        
        /* not working implementation */
        for junction in junctions {
            var relationships: [(element: Element, parent: Element)] = []
            
            var stack: Stack<Element> = Stack<Element>()
            stack.push(junction)
            
            while (stack.count > 0) {
                var current: Element = stack.pop()!;
                
                // base case
                if current is JunctionElement && current !== junction {
                    var goalElementsPath = [current]
                    // grab the traversals for the goal path
                    while (current !== junction) {
                        current = relationships.filter({ (relationship) -> Bool in
                            return relationship.element === current
                        })[0].parent
                        goalElementsPath.insert(current, at: 0)
                    }
                    junctionEdges.append(goalElementsPath)
                    continue
                }
                
                // process the data to be more parseable
                let adjacentEdges = self.edges.filter({ (edge) -> Bool in
                    return edge.from === current || edge.to === current
                })
                let adjacentVertices: [Element] = adjacentEdges.map({ (edge) -> Element in
                    if (edge.from === current) {
                        return edge.to
                    } else {
                        return edge.from
                    }
                })
                
                // DFS
                for vertex in adjacentVertices {
                    if !visitedElements.contains(where: { (element) -> Bool in
                        return element === vertex
                    }){
                        if !(vertex is JunctionElement) {
                            visitedElements.append(vertex)
                        }
                        relationships.append((element: vertex, parent: current))
                        stack.push(vertex)
                    }
                }
                
            }
        }
        
        return junctionEdges
    }
    
    /**
     DO THIS AFTER JUNCTION EDGES
     Direction is implicitly defined when we generated the junction edges
     We want to extract the current equations defined by Kirchhoff's Laws
     Each edge has a direction
     */
    func generateKirchhoffsCurrentMatrix(junctionEdges: [[Element]]) -> [[Int]] {
        var kirchhoffsMatrix: [[Int]] = [] // [[1,-1,0,0], ...]
        kirchhoffsMatrix.removeAll()
        for _ in 0..<junctions.count {
            kirchhoffsMatrix.append([Int](repeating: 0, count: junctionEdges.count))
        }
        
        for i in 0..<junctions.count {
            let junctionElem = junctions[i]
            for j in 0..<junctionEdges.count {
                if (junctionEdges[j].first === junctionElem) { // exiting junction
                    kirchhoffsMatrix[i][j] = 1
                } else if (junctionEdges[i].last === junctionElem) { // entering junction
                    kirchhoffsMatrix[i][j] = -1
                }
            }
        }
        
        return kirchhoffsMatrix
    }
    
    /**
     DO THIS AFTER KIRCHHOFFS CURRENT MATRIX
     The current matrix gives us a standard for direction, even though it's random. Our task now
     is to complete the rest of the matrix by exploring all combinations of cycles, and
     implementing a graph
     */
    func generateKirchhoffsVoltageMatrix(currentMatrix: [[Int]]) -> [[Int]] {
        
    }
}
