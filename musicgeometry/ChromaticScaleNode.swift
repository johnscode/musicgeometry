//
//  PolygonNode.swift
//  musicgeometry
//
//  Created by John Fowler on 12/31/24.
// Copyright (C) John J. Fowler 2024, 2025
//

import SpriteKit

protocol ChromaticScaleNodeDelegate: AnyObject {
    func chromaticScaleNode(_ scaleNode: ChromaticScaleNode, didTapVertexAt index: Int)
    func chromaticScaleNode(_ scaleNode: ChromaticScaleNode, didLongPressVertexAt index: Int)
    func chromaticScaleNode(_ scaleNode: ChromaticScaleNode, didBeginTouchingVertexAt index: Int)
    func chromaticScaleNode(_ scaleNode: ChromaticScaleNode, didCancelTouchingVertexAt index: Int)
}

class ChromaticScaleNode: SKNode {
    private let radius: CGFloat
    private let vertexRadius: CGFloat
    private var vertexNodes: [SKShapeNode] = []
  private var dataArray: [ScaleNote]
  
  weak var delegate: ChromaticScaleNodeDelegate?
  
  private var selectedVertexIndex: Int?
      private var longPressTimer: Timer?

private var connectionLines: [SKShapeNode] = []
    
  init(radius: CGFloat, vertexRadius: CGFloat, data: [ScaleNote]) {
        self.radius = radius
        self.vertexRadius = vertexRadius
        self.dataArray = data
        
        super.init()
    isUserInteractionEnabled = true
        
        guard data.count == 12 else {
            fatalError("Data array must contain exactly 12 elements")
        }
        
        setupPolygon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPolygon() {
        // Create the polygon outline
        let polygonPath = CGMutablePath()
        let vertices = calculateVertexPositions()
        
        // Draw the polygon outline
        polygonPath.move(to: vertices[0])
        for i in 1..<vertices.count {
            polygonPath.addLine(to: vertices[i])
        }
        polygonPath.closeSubpath()
        
        let polygonShape = SKShapeNode(path: polygonPath)
        polygonShape.strokeColor = .white
        polygonShape.lineWidth = 2.0
        polygonShape.fillColor = .clear
      polygonShape.zPosition = 5
        addChild(polygonShape)
        
        // Create vertex nodes
        for (index, position) in vertices.enumerated() {
            let vertexNode = createVertexNode(at: position)
          let scaleNote = getData(forVertex: index)!
          vertexNode.name = scaleNote.note.name
          vertexNode.fillColor = scaleNote.color
            vertexNodes.append(vertexNode)
            addChild(vertexNode)
        }
    }
    
    private func calculateVertexPositions() -> [CGPoint] {
        var vertices: [CGPoint] = []
        let angleStep = 2.0 * CGFloat.pi / 12.0
        
        // Start from the top (negative pi/2 to align first vertex at top)
        let startAngle = CGFloat.pi / 2.0
        
        for i in 0..<12 {
            let angle = startAngle - (CGFloat(i) * angleStep)
            let x = radius * cos(angle)
            let y = radius * sin(angle)
            vertices.append(CGPoint(x: x, y: y))
        }
        
        return vertices
    }
    
    private func createVertexNode(at position: CGPoint) -> SKShapeNode {
        let vertexNode = SKShapeNode(circleOfRadius: vertexRadius)
        vertexNode.position = position
        vertexNode.fillColor = .white
        vertexNode.strokeColor = .white
        vertexNode.lineWidth = 1.0
      vertexNode.isUserInteractionEnabled = false
      vertexNode.zPosition = 5
        return vertexNode
    }
    
    // Helper method to get data for a specific vertex
  func getData(forVertex index: Int) -> ScaleNote? {
        guard index >= 0 && index < dataArray.count else { return nil }
        return dataArray[index]
    }
    
    // Helper method to get vertex node at index
    func getVertexNode(at index: Int) -> SKShapeNode? {
        guard index >= 0 && index < vertexNodes.count else { return nil }
        return vertexNodes[index]
    }
  
  func drawConnectionsBetweenThirdVertices(startingAt startIndex: Int,
                                         lineColor: SKColor = .white,
                                         lineWidth: CGFloat = 2.0) {
      // Clear existing lines
      clearConnectionLines()
      
      // Ensure startIndex is valid
      let normalizedStartIndex = startIndex % vertexNodes.count
      
      // Create path for connections
      let path = CGMutablePath()
      var currentIndex = normalizedStartIndex
      let firstIndex = currentIndex // Store to check for completion
      var isFirstPoint = true
      
      repeat {
          let vertexNode = vertexNodes[currentIndex]
          let point = vertexNode.position
          
          if isFirstPoint {
              path.move(to: point)
              isFirstPoint = false
          } else {
              path.addLine(to: point)
          }
          
          // Move to next third vertex
          currentIndex = (currentIndex + 3) % vertexNodes.count
      } while currentIndex != firstIndex // Stop when we get back to start
      
      // Close the path if we have more than two points
      path.closeSubpath()
      
      // Create and configure the line node
      let lineNode = SKShapeNode(path: path)
      lineNode.strokeColor = lineColor
      lineNode.lineWidth = lineWidth
      lineNode.lineCap = .round
      lineNode.lineJoin = .round
      
      // Add to tracking array and as child
      connectionLines.append(lineNode)
      addChild(lineNode)
  }
  
  func clearConnectionLines() {
      connectionLines.forEach { $0.removeFromParent() }
      connectionLines.removeAll()
  }
  
  func animateConnectionsBetweenThirdVertices(startingAt startIndex: Int,
                                            lineColor: SKColor = .white,
                                            lineWidth: CGFloat = 2.0,
                                            duration: TimeInterval = 1.0) {
      clearConnectionLines()
      
      let normalizedStartIndex = startIndex % vertexNodes.count
      var points: [CGPoint] = []
      
      // Collect all points
      var currentIndex = normalizedStartIndex
      let firstIndex = currentIndex
      
      repeat {
          points.append(vertexNodes[currentIndex].position)
          currentIndex = (currentIndex + 3) % vertexNodes.count
      } while currentIndex != firstIndex
      
      // Add first point again to close the shape
      points.append(points[0])
      
      let lineNode = SKShapeNode()
      lineNode.strokeColor = lineColor
      lineNode.lineWidth = lineWidth
      lineNode.lineCap = .round
      lineNode.lineJoin = .round
      
      connectionLines.append(lineNode)
      addChild(lineNode)
      
      // Animate drawing the path
      let animation = SKAction.customAction(withDuration: duration) { [weak lineNode] node, time in
          guard let lineNode = lineNode else { return }
          
          let progress = time / CGFloat(duration)
          let pointCount = points.count
          let segmentProgress = progress * CGFloat(pointCount - 1)
          let currentSegment = Int(floor(segmentProgress))
          let segmentRemaining = segmentProgress - CGFloat(currentSegment)
          
          let currentPath = CGMutablePath()
          currentPath.move(to: points[0])
          
          // Draw completed segments
          if currentSegment > 0 {
              for i in 1...currentSegment {
                  currentPath.addLine(to: points[i])
              }
          }
          
          // Draw partial segment
          if currentSegment < pointCount - 1 {
              let startPoint = points[currentSegment]
              let endPoint = points[currentSegment + 1]
              let x = startPoint.x + (endPoint.x - startPoint.x) * segmentRemaining
              let y = startPoint.y + (endPoint.y - startPoint.y) * segmentRemaining
              currentPath.addLine(to: CGPoint(x: x, y: y))
          }
          
          lineNode.path = currentPath
      }
      
      lineNode.run(animation)
  }
  
  func highlightVertex(at index: Int) {
//    vertexNodes[index].strokeColor = .red
  }
  
  func unhighlightVertex(at index: Int) {
//    
//    let scaleNote = getData(forVertex: selectedVertexIndex!)!
//    vertexNodes[index].fillColor = scaleNote.color
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let touch = touches.first else { return }
      let location = touch.location(in: self)
      
      for (index, vertexNode) in vertexNodes.enumerated() {
          if vertexNode.contains(location) {
              selectedVertexIndex = index
              highlightVertex(at: index)
            
            let scaleNote = getData(forVertex: index)!
            print("touched note is \(scaleNote.note.name)")
            let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
//            let brighten = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
            let group = SKAction.sequence([scaleUp])
            
            vertexNode.run(group)
              
              // Setup long press detection
              longPressTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                  guard let self = self else { return }
                  self.delegate?.chromaticScaleNode(self, didLongPressVertexAt: index)
              }
              
              delegate?.chromaticScaleNode(self, didBeginTouchingVertexAt: index)
              break
          }
      }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let touch = touches.first,
            let selectedIndex = selectedVertexIndex else { return }
      
      let location = touch.location(in: self)
      if !vertexNodes[selectedIndex].contains(location) {
          // Touch moved outside the vertex
          longPressTimer?.invalidate()
          longPressTimer = nil
          unhighlightVertex(at: selectedIndex)
        let vertexNode = vertexNodes[selectedIndex]
        resetNode(node: vertexNode)
          delegate?.chromaticScaleNode(self, didCancelTouchingVertexAt: selectedIndex)
          selectedVertexIndex = nil
      }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let selectedIndex = selectedVertexIndex else { return }
    
    let vertexNode = vertexNodes[selectedIndex]
    let scaleNote = getData(forVertex: selectedIndex)!
    print("touch ended on \(scaleNote.note.name)")
    resetNode(node: vertexNode)
    
      longPressTimer?.invalidate()
      longPressTimer = nil
      unhighlightVertex(at: selectedIndex)
      
      delegate?.chromaticScaleNode(self, didTapVertexAt: selectedIndex)
      selectedVertexIndex = nil
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
      if let selectedIndex = selectedVertexIndex {
          longPressTimer?.invalidate()
          longPressTimer = nil
          unhighlightVertex(at: selectedIndex)
        let vertexNode = vertexNodes[selectedIndex]
        resetNode(node: vertexNode)
          delegate?.chromaticScaleNode(self, didCancelTouchingVertexAt: selectedIndex)
          selectedVertexIndex = nil
      }
  }
  
  private func resetNode(node: SKNode) {
    let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
//    let fadeBack = SKAction.fadeAlpha(to: 0.7, duration: 0.1)
    let group = SKAction.group([scaleDown])
    
    node.run(group)
  }
}
