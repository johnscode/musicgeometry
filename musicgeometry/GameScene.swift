//
//  GameScene.swift
//  musicgeometry
//
//  Created by John Fowler on 12/31/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, ChromaticScaleNodeDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
  
  private var viewSize: CGSize
  private let audioControl = AudioControl()
  
  var chromaticScale = Scale.createChromaticScale()
    
  
  override required init(size: CGSize) {
    self.viewSize = size
    super.init(size: size)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func computeScaleSize(viewSize: CGSize) -> Double {
    let minDim = min(viewSize.height, viewSize.width)
    return minDim*0.4
  }
  
  override func didMove(to view: SKView) {
        self.audioControl.start()
      // Create the polygon node
    let radius = computeScaleSize(viewSize: viewSize)
      let polygonNode = ChromaticScaleNode(radius: radius, vertexRadius: 20, data: chromaticScale.notes)
      polygonNode.position = CGPoint(x: frame.midX, y: frame.midY)
      addChild(polygonNode)
      polygonNode.delegate = self
    }
  
  // MARK: polygon delegate
  func chromaticScaleNode(_ scaleNode: ChromaticScaleNode, didTapVertexAt index: Int) {
    print("tap at \(index)")
//    scaleNode.animateConnectionsBetweenThirdVertices(startingAt: index, lineColor: .blue, lineWidth: 2)
  }
  func chromaticScaleNode(_ scaleNode: ChromaticScaleNode, didLongPressVertexAt index: Int) {
    
  }
  func chromaticScaleNode(_ scaleNode: ChromaticScaleNode, didBeginTouchingVertexAt index: Int) {
    if let scaleNote = scaleNode.getData(forVertex: index) {
      self.audioControl.playNote(keyNumber: Int8(scaleNote.note.midi()), velocity: 127)
    }
  }
  func chromaticScaleNode(_ scaleNode: ChromaticScaleNode, didCancelTouchingVertexAt index: Int) {
    if let scaleNote = scaleNode.getData(forVertex: index) {
      self.audioControl.stopNote(keyNumber: Int8(scaleNote.note.midi()))
    }
  }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
