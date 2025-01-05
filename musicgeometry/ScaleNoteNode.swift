//
//  ScaleNoteNode.swift
//  musicgeometry
//
//  Created by John Fowler on 1/4/25.
// Copyright (C) John J. Fowler 2024, 2025
//

import UIKit
import SpriteKit

protocol ScaleNoteDelegate {
  func tappedNote(_ scaleNote: ScaleNote, at: Date)
  func longPressNote(_ scaleNote: ScaleNote, at: Date)
  func beginTouchNote(_ scaleNote: ScaleNote, at: Date)
  func endTouchNote(_ scaleNote: ScaleNote, at: Date)
  func moveTouchNote(_ scaleNote: ScaleNote, at: Date)
}

class ScaleNoteNode: SKShapeNode {
  
  private var _scaleNote: ScaleNote
  var scaleNote: ScaleNote {
    get { return _scaleNote }
  }
  
  private var longPressTimer: Timer?
  
  private var _noteEnabled: Bool = true
  var noteEnabled: Bool {
    get { return _noteEnabled }
    set {
      _noteEnabled = newValue
      setAppearance()
    }
  }
  var delegate: ScaleNoteDelegate?
  
  init(scaleNote: ScaleNote, at: CGPoint, radius: Double, enabled: Bool) {
    self._scaleNote = scaleNote
    self._noteEnabled = enabled
    super.init()
    let circlePath = CGPath(ellipseIn: CGRect(x: -radius, y: -radius, width: radius * 2, height: radius * 2), transform: nil)
    self.path = circlePath
    self.position = at
    self.lineWidth = 1.0
    self.zPosition = 5
    self.name = scaleNote.note.name
    setAppearance()
  }
  
  func setAppearance() {
    if _noteEnabled {
      self.strokeColor = .white
      self.fillColor = scaleNote.color
      self.isUserInteractionEnabled = true
    } else {
      self.strokeColor = .lightGray
      self.fillColor = UIColor.lightGray
      self.isUserInteractionEnabled = false
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func simulatePress(duration: TimeInterval = 0.5) {
    let touchDnAction = SKAction.run {
      self.handleTouchDown()
    }
    let delayAction = SKAction.wait(forDuration: duration)
    let touchUpAction = SKAction.run {
      self.handleTouchUp()
    }
    let sequence = SKAction.sequence([touchDnAction, delayAction, touchUpAction])
    self.run(sequence)
  }
  
  private func highlight() {
    let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
    //            let brighten = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
    let group = SKAction.sequence([scaleUp])
    
    self.run(group)
  }
  
  private func unhighlight() {
    let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
    //    let fadeBack = SKAction.fadeAlpha(to: 0.7, duration: 0.1)
    let group = SKAction.group([scaleDown])
    
    self.run(group)
  }
  
  func handleTouchDown() {
    if !_noteEnabled { return }
    print("touchesBegan on note \(scaleNote.note.name) \(_noteEnabled)")
    // Setup long press detection
    longPressTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
      guard let self = self else { return }
      self.delegate?.longPressNote(scaleNote, at: Date.now)
    }
    highlight()
    self.delegate?.beginTouchNote(scaleNote, at: Date.now)
  }
  
  func handleTouchUp() {
    if !_noteEnabled { return }
      // Handle touch ended
    print("touchesEnded on note \(scaleNote.note.name) \(_noteEnabled)")
    unhighlight()
    longPressTimer?.invalidate()
    longPressTimer = nil
    self.delegate?.endTouchNote(scaleNote, at: Date.now)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    handleTouchDown()
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !_noteEnabled { return }
      // Handle touch moved
    print("touchesMoved on note \(scaleNote.note.name) \(_noteEnabled)")
    unhighlight()
    longPressTimer?.invalidate()
    longPressTimer = nil
    self.delegate?.moveTouchNote(scaleNote, at: Date.now)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    handleTouchUp()
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !_noteEnabled { return }
      // Handle touch cancelled
    print("touchesCancelled on note \(scaleNote.note.name) \(_noteEnabled)")
    unhighlight()
    longPressTimer?.invalidate()
    longPressTimer = nil
    self.delegate?.endTouchNote(scaleNote, at: Date.now)
  }
  
}
