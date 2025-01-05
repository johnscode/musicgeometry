//
//  ChromaticScaleScene.swift
//  musicgeometry
//
//  Created by John Fowler on 12/31/24.
// Copyright (C) John J. Fowler 2024, 2025
//

import SpriteKit
import GameplayKit

class ChromaticScaleScene: SKScene, ScaleNoteDelegate, ChromaticScaleNodeDelegate {
  private var chromaticScaleNode: ChromaticScaleNode?
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
    // Adjust the multiplier based on orientation
    let multiplier: CGFloat = viewSize.width > viewSize.height ? 0.3 : 0.4
    return minDim * multiplier
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
    chromaticScaleNode = ChromaticScaleNode(radius: radius, vertexRadius: vertexRadius, noteListener: self)
    if let polygonNode = chromaticScaleNode {
      polygonNode.position = CGPoint(x: frame.midX, y: frame.midY)
      addChild(polygonNode)
      polygonNode.delegate = self
    }
  }
  
  private func computeVertexRadius(viewSize: CGSize) -> CGFloat {
    let minDim = min(viewSize.height, viewSize.width)
    return minDim * 0.03 // Adjust this multiplier as needed
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
      self.audioControl.playNote(keyNumber: Int8(scaleNote.0.note.midi()), velocity: 127)
    }
  }
  func chromaticScaleNode(_ scaleNode: ChromaticScaleNode, didCancelTouchingVertexAt index: Int) {
    if let scaleNote = scaleNode.getData(forVertex: index) {
      self.audioControl.stopNote(keyNumber: Int8(scaleNote.0.note.midi()))
    }
  }
  
  
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
}
