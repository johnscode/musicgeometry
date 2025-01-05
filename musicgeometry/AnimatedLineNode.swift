//
//  AnimatedLineNode.swift
//  jam
//
//  Created by John Fowler on 1/5/25.
//

import SpriteKit

class AnimatedLineNode: SKShapeNode {
    private var fromPoint: CGPoint
    private var toPoint: CGPoint
    private var progress: CGFloat = 0
    
    init(from: CGPoint, to: CGPoint) {
        self.fromPoint = from
        self.toPoint = to
        super.init()
        
        self.strokeColor = .white
        self.lineWidth = 2.0
        self.lineCap = .round
        
        updatePath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updatePath() {
        let currentX = fromPoint.x + (toPoint.x - fromPoint.x) * progress
        let currentY = fromPoint.y + (toPoint.y - fromPoint.y) * progress
        
        let path = CGMutablePath()
        path.move(to: fromPoint)
        path.addLine(to: CGPoint(x: currentX, y: currentY))
        self.path = path
    }
    
    func animate(duration: TimeInterval) {
        let animation = SKAction.customAction(withDuration: duration) { [weak self] _, elapsedTime in
            self?.progress = elapsedTime / CGFloat(duration)
            self?.updatePath()
        }
        
        self.run(animation)
    }
}
