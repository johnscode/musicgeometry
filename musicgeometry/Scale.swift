//
//  Scale.swift
//  musicgeometry
//
//  Created by John Fowler on 12/31/24.
// Copyright (C) John J. Fowler 2024, 2025
//

import UIKit

class ScaleNote {
  var note: MidiNote
  var color: UIColor
  init(note: MidiNote, color: UIColor) {
    self.note = note
    self.color = color
  }
  
  static func makeScaleNote(note: MidiNote) -> ScaleNote {
    return ScaleNote(note: note, color: ScaleNote.colorForNote(note: note))
  }
  
  static private func colorForNote(note: MidiNote) -> UIColor {
    switch note.note {
    case .C:      return UIColor(hex: "FF0000") //(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.0) // Red
    case .Cs: return UIColor(hex: "20B2AA") //return UIColor(red: 1.00, green: 0.27, blue: 0.00, alpha: 1.0) // Red-Orange
    case .D:  return UIColor(hex: "FFA500") //return UIColor(red: 1.00, green: 0.55, blue: 0.00, alpha: 1.0) // Orange
    case .Ds: return UIColor(hex: "0000FF") //return UIColor(red: 1.00, green: 0.77, blue: 0.00, alpha: 1.0) // Orange-Yellow
    case .E: return UIColor(hex: "FFFF00") //return UIColor(red: 1.00, green: 1.00, blue: 0.00, alpha: 1.0) // Yellow
    case .F: return UIColor(hex: "FF1493") //return UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.0) // Green
    case .Fs: return UIColor(hex: "00FF00") //return UIColor(red: 0.00, green: 1.00, blue: 0.50, alpha: 1.0) // Green-Blue
    case .G:  return UIColor(hex: "FF4500") //return UIColor(red: 0.00, green: 0.00, blue: 1.00, alpha: 1.0) // Blue
    case .Gs: return UIColor(hex: "00FFFF") //return UIColor(red: 0.29, green: 0.00, blue: 0.51, alpha: 1.0) // Blue-Indigo
    case .A:  return UIColor(hex: "FFD700") //return UIColor(red: 0.58, green: 0.00, blue: 0.83, alpha: 1.0) // Indigo
    case .As: return UIColor(hex: "8A2BE2") //return UIColor(red: 0.75, green: 0.00, blue: 0.83, alpha: 1.0) // Indigo-Violet
    case .B:  return UIColor(hex: "ADFF2F") //return UIColor(red: 0.93, green: 0.51, blue: 0.93, alpha: 1.0) // Violet
    }
    
  }
}

class Scale {
  
  private var _notes: [ScaleNote]
  var notes: [ScaleNote] {
    get { return _notes }
  }
  
  init(notes: [ScaleNote]) {
    self._notes = notes
  }
  
  static func createChromaticScale() -> Scale {
    return Scale(notes: [
      ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .C)),
      ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .Cs)),
      ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .D)),
      ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .Ds)),
      ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .E)),
      ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .F)),
      ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .Fs)),
      ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .G)),
      ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .Gs)),
      ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .A)),
      ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .As)),
      ScaleNote.makeScaleNote(note: MidiNote(octave: .four, note: .B)),
    ])
  }
  
  
}
