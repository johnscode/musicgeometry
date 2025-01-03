//
//  GameViewController.swift
//  musicgeometry
//
//  Created by John Fowler on 12/31/24.
// Copyright (C) John J. Fowler 2024, 2025
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  override func loadView() {
    super.loadView()
    
    // Create an SKView and set it as the main view for this view controller
    let skView = SKView(frame: self.view.bounds)
    self.view = skView  // Make SKView the root view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let view = self.view as! SKView? {
      let scene = GameScene(size: view.bounds.size)
      scene.scaleMode = .aspectFill
      view.presentScene(scene)
      
      view.ignoresSiblingOrder = true
      view.showsFPS = true
      view.showsNodeCount = true
      
      view.ignoresSiblingOrder = true
      view.showsFPS = true
      view.showsNodeCount = true
      
      view.isMultipleTouchEnabled = true
    }
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
