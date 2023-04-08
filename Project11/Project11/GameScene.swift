//
//  GameScene.swift
//  Project11
//
//  Created by Giorgio Latour on 4/8/23.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var ballImages: [String] = ["ballRed", "ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballYellow"]
    
    var gameOverLabel: SKLabelNode!
    
    var ballsAvailableLabel: SKLabelNode!
    var ballsAvailable = 5 {
        didSet {
            if ballsAvailable <= 0 {
                gameOverLabel.text = "GAME OVER!"
                restartLabel.text = "RESTART?"
            }
            ballsAvailableLabel.text = "Balls Available: \(ballsAvailable)"
        }
    }
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    var restartLabel: SKLabelNode!
    var restartMode: Bool = false {
        didSet {
            if restartMode {
                score = 0
                ballsAvailable = 5
                gameOverLabel.text = ""
                restartLabel.text = ""
                restartMode.toggle()
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.horizontalAlignmentMode = .right
        editLabel.position = CGPoint(x: 100, y: 700)
        addChild(editLabel)
        
        ballsAvailableLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsAvailableLabel.text = "Balls Available: 5"
        ballsAvailableLabel.horizontalAlignmentMode = .center
        ballsAvailableLabel.position = CGPoint(x: 490, y: 700)
        addChild(ballsAvailableLabel)
        
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.fontSize = 50
        gameOverLabel.text = ""
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.position = CGPoint(x: 512, y: 359)
        addChild(gameOverLabel)
        
        restartLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartLabel.fontSize = 40
        restartLabel.text = ""
        restartLabel.horizontalAlignmentMode = .center
        restartLabel.position = CGPoint(x: 512, y: 280)
        addChild(restartLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        for _ in 0...35 {
            let randomPoint = CGPoint(x: CGFloat.random(in: 100...900), y: CGFloat.random(in: 150...600))
            makeRandomBox(at: randomPoint)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if ballsAvailable > 0 {
            if objects.contains(editLabel) {
                editingMode.toggle()
            } else {
                if editingMode {
                    makeRandomBox(at: location)
                } else {
                    let ball = SKSpriteNode(imageNamed: ballImages.randomElement() ?? "ballRed")
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.restitution = 0.4
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                    ball.position.x = location.x
                    ball.position.y = 700
                    ball.name = "ball"
                    addChild(ball)
                }
            }
        } else {
            if objects.contains(restartLabel) {
                restartMode.toggle()
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        
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
    
    func makeRandomBox(at location: CGPoint) {
        // create a box
        let size = CGSize(width: Int.random(in: 16...128), height: 16)
        let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
        box.zRotation = CGFloat.random(in: 0...3)
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        box.name = "box"
        addChild(box)
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            ballsAvailable += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
            ballsAvailable -= 1
        } else if object.name == "box" {
            destroy(box: object)
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    func destroy(box: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = box.position
            addChild(fireParticles)
        }
        box.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
}
