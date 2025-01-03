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
  private var gameScene: GameScene?
  
  override func loadView() {
    super.loadView()
    
    // Create an SKView and set it as the main view for this view controller
    let skView = SKView(frame: self.view.bounds)
    self.view = skView  // Make SKView the root view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupScene()
  }
  
  private func setupScene() {
      if let view = self.view as? SKView {
          let scene = GameScene(size: view.bounds.size)
          gameScene = scene
          scene.scaleMode = .resizeFill // Change this from aspectFill
          view.presentScene(scene)
          
          view.ignoresSiblingOrder = true
          view.showsFPS = true
          view.showsNodeCount = true
          view.isMultipleTouchEnabled = true
      }
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    coordinator.animate { [weak self] _ in
        if let view = self?.view as? SKView {
            view.bounds = CGRect(origin: .zero, size: size)
            self?.gameScene?.size = size
        }
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
