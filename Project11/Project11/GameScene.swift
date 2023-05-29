//
//  GameScene.swift
//  Project11
//
//  Created by Ning, Xinran on 29/5/23.
//

import SpriteKit

class GameScene: SKScene {
  override func didMove(to view: SKView) {
    let background = SKSpriteNode(imageNamed: "background")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)

    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)  // physicsBody for the whole scene
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)  // where the touch was in the whole gamee scene
    let box = SKSpriteNode(color: .red, size: CGSize(width: 54, height: 54))  // create a box there
    box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 54, height: 54))
    box.position = location
    addChild(box)
  }
}
