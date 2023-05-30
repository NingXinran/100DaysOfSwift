//
//  GameScene.swift
//  Project11
//
//  Created by Ning, Xinran on 29/5/23.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

  var scoreLabel: SKLabelNode!

  var score = 0 {
    didSet { scoreLabel.text = "Score: \(score)"}
  }
  var editLabel: SKLabelNode!
  var editing: Bool = false {
    didSet {
      if editing {
        editLabel.text = "Done"
      } else {
        editLabel.text = "Edit"
      }
    }
  }

  override func didMove(to view: SKView) {
    let background = SKSpriteNode(imageNamed: "background")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)

    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)  // physicsBody for the whole scene
    physicsWorld.contactDelegate = self

    // Create slots
    makeSlot(at: CGPoint(x:128, y:0), isGood: true)
    makeSlot(at: CGPoint(x:384, y:0), isGood: false)
    makeSlot(at: CGPoint(x:640, y:0), isGood: true)
    makeSlot(at: CGPoint(x:896, y:0), isGood: false)

    makeBouncer(at: CGPoint(x:0, y:0))
    makeBouncer(at: CGPoint(x:256, y:0))
    makeBouncer(at: CGPoint(x:512, y:0))
    makeBouncer(at: CGPoint(x:768, y:0))
    makeBouncer(at: CGPoint(x:1024, y:0))

    // Create scorelabel
    scoreLabel = SKLabelNode()
    scoreLabel.text = "Score: 0"
    scoreLabel.horizontalAlignmentMode = .right
    scoreLabel.position = CGPoint(x: 980, y:700)
    addChild(scoreLabel)

    // Add editLabel
    editLabel = SKLabelNode()
    editLabel.text = "Edit"
    editLabel.position = CGPoint(x: 80, y: 700)
    addChild(editLabel)

  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)  // where the touch was in the whole gamee scene

    // Check if edit button was tapped
    let objects = nodes(at: location)  // what nodes exist at this location
    if objects.contains(editLabel) {
      editing.toggle()
    } else {
      if editing {  //  in editing mode: create boxes
        let size = CGSize(width: Int.random(in: 16...120), height: 16)
        let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1),
                                              green: CGFloat.random(in: 0...1),
                                              blue: CGFloat.random(in: 0...1),
                                              alpha: 1),
                               size: size)
        box.zRotation = CGFloat.random(in:0...3)
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        addChild(box)
      } else {  // NOT in editing mode: create balls
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody?.restitution = 0.4
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0  // tell us about collisions everywhere on the ball
        ball.position = location
        ball.name = "ball"
        addChild(ball)
      }

    }

  }

  func makeBouncer(at position: CGPoint) {
    // Add bouncer
    let bouncer = SKSpriteNode(imageNamed: "bouncer")
    bouncer.position = position
    bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
    bouncer.physicsBody?.isDynamic = false  // collides with other things but fixed in place
    addChild(bouncer)
  }

  func makeSlot(at position: CGPoint, isGood: Bool) {
    var slotBase: SKSpriteNode
    var slotGlow: SKSpriteNode

    if isGood {
      slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
      slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
      slotBase.name = "good"
    } else {
      slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
      slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
      slotBase.name = "bad"
    }

    slotBase.position = position
    slotGlow.position = position

    slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
    slotBase.physicsBody?.isDynamic = false

    addChild(slotBase)
    addChild(slotGlow)

    let spin = SKAction.rotate(byAngle: .pi, duration: 10)
    let spinForever = SKAction.repeatForever(spin)
    slotGlow.run(spinForever)
  }

  func collision(between ball: SKNode, object: SKNode) {  // SKNode is the parent class of SKSpriteNode
    if object.name == "good" {
      destroy(ball: ball)
      score += 1
    } else if object.name == "bad" {
      destroy(ball: ball)
      score -= 1
    }
  }

  func destroy(ball: SKNode) {
    ball.removeFromParent()
  }

  func didBegin(_ contact: SKPhysicsContact) {
    // In case two collisions are registered for the same contact
    guard let nodeA = contact.bodyA.node else { return }
    guard let nodeB = contact.bodyB.node else { return }
    if nodeA.name == "ball" {
      collision(between: nodeA, object: nodeB)
    } else if nodeB.name == "ball" {
      collision(between: nodeB, object: nodeA)
    }
  }
}
