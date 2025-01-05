//
//  CMajorScaleNode.swift
//  musicgeometry
//
//  Created by John Fowler on 1/4/25.
//

import UIKit
import SpriteKit

class CMajorScaleNode: ChromaticScaleNode {
  
  private var cMajorScale: Scale = Scale.createCMajorScale()
  
  override init(radius: CGFloat, vertexRadius: CGFloat, noteListener: any ScaleNoteDelegate) {
    
    let chromaticScale = CMajorScaleNode.createCMajorScaleData()
    super.init(radius: radius, vertexRadius: vertexRadius, noteListener: noteListener, data: chromaticScale)
    
//    let disabledNotes: [ScaleNote] = [
//        ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .Cs)),
//        ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .Ds)),
//        ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .Fs)),
//        ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .Gs)),
//        ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .As)),
//    ]
  }
  
  @MainActor required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setupPolygon(noteListener: any ScaleNoteDelegate) {
    super.setupPolygon(noteListener: noteListener)
    outlineNode.strokeColor = UIColor(white: 0.75, alpha: 1)
//    drawUniformPolygonForScale()
    drawColoredPolygonForScale()
  }
  
  func drawColoredPolygonForScale() {
    let vertices = vertexNodes
    let enabledVertices: [ScaleNoteNode] = vertices.filter { $0.noteEnabled }
    if enabledVertices.isEmpty {
      print("no enabled notes in this scale")
      return
    }
    // Create the polygon outline
    let polygonNode = SKNode()
    for i in 0..<enabledVertices.count {
      let startPoint = enabledVertices[i].position
      let endPoint = enabledVertices[(i + 1) % enabledVertices.count].position // Get the end point (wrap if at the end)
      let path = CGMutablePath()
                  path.move(to: startPoint)
                  path.addLine(to: endPoint)
      let lineNode = SKShapeNode(path: path)
      lineNode.strokeColor = enabledVertices[i].fillColor
                  lineNode.lineWidth = 2.0
      polygonNode.addChild(lineNode)
    }
    addChild(polygonNode)
  }
  
  func drawUniformPolygonForScale() {
    let vertices = vertexNodes
    let enabledVertices: [ScaleNoteNode] = vertices.filter { $0.noteEnabled }
    if enabledVertices.isEmpty {
      print("no enabled notes in this scale")
      return
    }
    // Create the polygon outline
    let polygonPath = CGMutablePath()
    // Draw the polygon outline
    polygonPath.move(to: enabledVertices[0].position)
    for i in 1..<enabledVertices.count {
      polygonPath.addLine(to: enabledVertices[i].position)
      
    }
    polygonPath.closeSubpath()
    
    let polygonShape = SKShapeNode(path: polygonPath)
    polygonShape.strokeColor = .white
    polygonShape.lineWidth = 2.0
    polygonShape.fillColor = .clear
    polygonShape.zPosition = 4
    addChild(polygonShape)
  }
  
  static func createCMajorScaleData() -> [(ScaleNote,Bool)] {
    return [
      (ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .C)), true),
      (ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .Cs)), false),
      (ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .D)), true),
      (ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .Ds)), false),
      (ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .E)), true),
      (ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .F)), true),
      (ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .Fs)), false),
      (ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .G)), true),
      (ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .Gs)), false),
      (ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .A)), true),
      (ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .As)), false),
      (ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .B)), true),
    ]
  }
}
