//
//  CMajorScaleScene.swift
//  musicgeometry
//
//  Created by John Fowler on 1/4/25.
//

import UIKit
import SpriteKit

class CMajorScaleScene: SKScene, ScaleNoteDelegate {
  
  private var chromaticScaleNode: CMajorScaleNode?
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
  
  override func didMove(to view: SKView) {
    self.audioControl.start()
    setupChromaticScale()
  }
  
  override func didChangeSize(_ oldSize: CGSize) {
    super.didChangeSize(oldSize)
    setupChromaticScale()
  }
  
  private func setupChromaticScale() {
    // Remove existing scale node if it exists
    chromaticScaleNode?.removeFromParent()
    
    let radius = computeScaleSize(viewSize: self.size)
    let vertexRadius = computeVertexRadius(viewSize: self.size)
    chromaticScaleNode = CMajorScaleNode(radius: radius, vertexRadius: vertexRadius, noteListener: self)
    if let polygonNode = chromaticScaleNode {
      polygonNode.position = CGPoint(x: frame.midX, y: frame.midY)
      addChild(polygonNode)
    }
  }
  
  private func computeScaleSize(viewSize: CGSize) -> Double {
    let minDim = min(viewSize.height, viewSize.width)
    // Adjust the multiplier based on orientation
    let multiplier: CGFloat = viewSize.width > viewSize.height ? 0.28 : 0.375
    return minDim * multiplier
  }
  
  private func computeVertexRadius(viewSize: CGSize) -> CGFloat {
    let minDim = min(viewSize.height, viewSize.width)
    return minDim * 0.04 // Adjust this multiplier as needed
  }
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
  }
  
  // MARK: ScaleNoteDelegate
  func tappedNote(_ scaleNote: ScaleNote, at: Date) {
    print("scene: tappedNote on \(scaleNote.note.name)")
  }
  
  func longPressNote(_ scaleNote: ScaleNote, at: Date) {
    print("scene: longPressNote on \(scaleNote.note.name)")
  }
  
  func beginTouchNote(_ scaleNote: ScaleNote, at: Date) {
    self.audioControl.playNote(keyNumber: Int8(scaleNote.note.midi()), velocity: 127)
  }
  
  func endTouchNote(_ scaleNote: ScaleNote, at: Date) {
    self.audioControl.stopNote(keyNumber: Int8(scaleNote.note.midi()))
  }
  
  func moveTouchNote(_ scaleNote: ScaleNote, at: Date) {
    print("scene: moveTouchNote on \(scaleNote.note.name)")
  }
  
  // MARK: touch events
  
  func touchDown(atPoint pos : CGPoint) {
    
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    
  }
  
  func touchUp(atPoint pos : CGPoint) {
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    
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
  
}
