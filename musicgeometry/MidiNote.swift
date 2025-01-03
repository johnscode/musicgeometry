//
//  MidiNote.swift
//  musicgeometry
//
//  Created by John Fowler on 12/31/24.
// Copyright (C) John J. Fowler 2024, 2025
//
// This uses the "C4" convention for middle C

enum Octave: Int {
  case zero = 0
  case one = 1
  case two = 2
  case three = 3
  case four = 4
  case five = 5
  case six = 6
  case seven = 7
  
  var name: String {
    return "\(rawValue)"
  }
}

enum BaseNote: Int {
  case C = 0, Cs=1, D=2, Ds=3, E=4, F=5, Fs=6, G=7, Gs=8, A=9, As=10, B=11
  
  var name: String {
    return String(describing: self)
  }
  
  var UIName: String {
    switch self {
    case .C: return "C"
    case .D: return "D"
    case .E: return "E"
    case .F: return "F"
    case .G: return "G"
    case .A: return "A"
    case .B: return "B"
    case .Cs: return "C#"
    case .Ds: return "D#"
    case .Fs: return "F#"
    case .Gs: return "G#"
    case .As: return "A#"
    }
  }
}

class MidiNote {
  private var _octave: Octave
  var octave: Octave {
    get { return _octave }
  }
  private var _note: BaseNote
  var note: BaseNote {
    get { return _note }
  }
  
  init(octave: Octave, note: BaseNote) {
    self._octave = octave
    self._note = note
  }
  
  func midi() -> Int {
    return (1+_octave.rawValue)*12 + _note.rawValue
  }
  
  var name: String {
    return "\(_note.UIName)\(_octave.name)"
  }

}
