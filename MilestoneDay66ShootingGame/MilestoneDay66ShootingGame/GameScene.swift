//
//  GameScene.swift
//  MilestoneDay66ShootingGame
//
//  Created by Giorgio Latour on 5/4/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameScore: SKLabelNode!
    var score: Int = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
            finalScoreLabel.text = "Final Score: \(score)"
        }
    }
    
    var reloadLabel: SKLabelNode!
    var yesLabel: SKLabelNode!
    var noLabel: SKLabelNode!
    
    var bulletsLeft: Int = 6
    var bullets = [SKSpriteNode]()
    var needToReload = false {
        didSet {
            if needToReload {
                reloadLabel.isHidden = false
                yesLabel.isHidden = false
                noLabel.isHidden = false
                needToReload = false
            }
        }
    }
    
    var finalScoreLabel: SKLabelNode!
    
    var possibleDucks = ["duck_outline_brown", "duck_outline_white", "duck_outline_yellow"]
    var ducksCreated = 0
    
    var isGameOver = false
    var createDuckTimeInterval = 2.0
    
    var gameTimer: Timer?
    var gameTime = 60 {
        didSet {
            gameTimeLabel.text = "Time Left: \(gameTime)"
        }
    }
    var gameTimeLabel: SKLabelNode!
    
    var createDuckTimer: Timer?
    
    override func didMove(to view: SKView) {
        let background1 = SKSpriteNode(imageNamed: "bg_wood")
        background1.position = CGPoint(x: 342, y: 768)
        background1.blendMode = .replace
        background1.size = CGSize(width: view.frame.width/2, height: view.frame.height/2)
        background1.zPosition = -20
        addChild(background1)
        
        let background2 = SKSpriteNode(imageNamed: "bg_wood")
        background2.position = CGPoint(x: 342, y: 256)
        background2.blendMode = .replace
        background2.size = CGSize(width: view.frame.width/2, height: view.frame.height/2)
        background2.zPosition = -20
        addChild(background2)
        
        let background3 = SKSpriteNode(imageNamed: "bg_wood")
        background3.position = CGPoint(x: 1024, y: 768)
        background3.blendMode = .replace
        background3.size = CGSize(width: view.frame.width/2, height: view.frame.height/2)
        background3.zPosition = -20
        addChild(background3)
        
        let background4 = SKSpriteNode(imageNamed: "bg_wood")
        background4.position = CGPoint(x: 1024, y: 256)
        background4.blendMode = .replace
        background4.size = CGSize(width: view.frame.width/2, height: view.frame.height/2)
        background4.zPosition = -20
        addChild(background4)
        
        let leftCurtain = SKSpriteNode(imageNamed: "leftCurtain")
        leftCurtain.position = CGPoint(x: 98, y: 500)
        leftCurtain.size.height = view.frame.height/1.2
        leftCurtain.size.width *= 1.5
        leftCurtain.zPosition = -2
        addChild(leftCurtain)
        
        let rightCurtain = SKSpriteNode(imageNamed: "rightCurtain")
        rightCurtain.position = CGPoint(x: 1268, y: 500)
        rightCurtain.size.height = view.frame.height/1.2
        rightCurtain.size.width *= 1.5
        rightCurtain.zPosition = -2
        addChild(rightCurtain)
        
        for i in 0...3 {
            let topCurtainStraight = SKSpriteNode(imageNamed: "curtainStraight")
            topCurtainStraight.position = CGPoint(x: 128 + i*384, y: 984)
            topCurtainStraight.size.height *= 2.5
            topCurtainStraight.size.width *= 2
            topCurtainStraight.zPosition = -1
            addChild(topCurtainStraight)
        }
        
        for i in 0...9 {
            let water = SKSpriteNode(imageNamed: "water")
            water.position = CGPoint(x: 128 + i*132, y: 250)
            water.zPosition = -5
            addChild(water)
        }
        
        for i in 0...9 {
            let water = SKSpriteNode(imageNamed: "water")
            water.position = CGPoint(x: 50 + i*132, y: 350)
            water.zPosition = -6
            
            addChild(water)
        }
        
        for i in 0...10 {
            let water = SKSpriteNode(imageNamed: "water")
            water.position = CGPoint(x: 0 + i*132, y: 450)
            water.zPosition = -7
            
            addChild(water)
        }
        
        addBullets()
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 50, y: 950)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        gameTimeLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameTimeLabel.text = "Time Left: 0"
        gameTimeLabel.position = CGPoint(x: 1250, y: 950)
        gameTimeLabel.horizontalAlignmentMode = .right
        gameTimeLabel.fontSize = 48
        addChild(gameTimeLabel)
        
        gameTime = 60
        
        reloadLabel = SKLabelNode(fontNamed: "Chalkduster")
        reloadLabel.text = "Reload for 10 points?"
        reloadLabel.position = CGPoint(x: 683, y: 700)
        reloadLabel.horizontalAlignmentMode = .center
        reloadLabel.fontSize = 48
        reloadLabel.isHidden = true
        addChild(reloadLabel)
        
        yesLabel = SKLabelNode(fontNamed: "Chalkduster")
        yesLabel.text = "YES"
        yesLabel.name = "playerAskedToReload"
        yesLabel.position = CGPoint(x: 580, y: 600)
        yesLabel.horizontalAlignmentMode = .center
        yesLabel.fontSize = 48
        yesLabel.isHidden = true
        addChild(yesLabel)
        
        noLabel = SKLabelNode(fontNamed: "Chalkduster")
        noLabel.text = "NO"
        noLabel.name = "playerDidNotAskToReload"
        noLabel.position = CGPoint(x: 780, y: 600)
        noLabel.horizontalAlignmentMode = .center
        noLabel.fontSize = 48
        noLabel.isHidden = true
        addChild(noLabel)
        
        finalScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        finalScoreLabel.text = "Final Score: \(score)"
        finalScoreLabel.name = "finalScoreLabel"
        finalScoreLabel.position = CGPoint(x: 683, y: 700)
        finalScoreLabel.horizontalAlignmentMode = .center
        finalScoreLabel.fontSize = 48
        finalScoreLabel.isHidden = true
        addChild(finalScoreLabel)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        if !isGameOver {
            createDuckTimer = Timer.scheduledTimer(timeInterval: createDuckTimeInterval, target: self, selector: #selector(createDuck), userInfo: nil, repeats: true)
            gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for node in nodes(at: location) {
            if node.name == "badDuck" {
                score += 50
                
                let explosion = SKEmitterNode(fileNamed: "explosion")!
                explosion.position = node.position
                addChild(explosion)
                
                node.removeFromParent()
                
                run(SKAction.playSoundFileNamed("quack.wav", waitForCompletion: false))
            } else if node.name == "goodDuck" {
                score -= 10
                
                let explosion = SKEmitterNode(fileNamed: "explosion")!
                explosion.position = node.position
                addChild(explosion)
                
                node.removeFromParent()
                
                run(SKAction.playSoundFileNamed("quack.wav", waitForCompletion: false))
            }
            
            if node.name == "playerAskedToReload" {
                addBullets()
                score -= 10
                
                hideReloadMessage()
                
                return
            } else if node.name == "playerDidNotAskToReload" {
                isGameOver = true
                
                hideReloadMessage()
                
                return
            }
        }
        
        if !bullets.isEmpty {
            if let bullet = bullets.last {
                bullet.removeFromParent()
                let _ = bullets.popLast()
                
                if bullets.isEmpty && !isGameOver {
                    needToReload = true
                }
            }
            run(SKAction.playSoundFileNamed("shotgun.wav", waitForCompletion: false))
        } else {
            needToReload = true
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x > 1400 || node.position.x < 0 {
                node.removeFromParent()
            }
        }
        
        if isGameOver {
            createDuckTimer?.invalidate()
            gameTimer?.invalidate()
            
            showFinalScore()
        }
    }
    
    func addBullets() {
        for i in 0...6 {
            let bullet = SKSpriteNode(imageNamed: "iconBulletGoldLong")
            bullet.position = CGPoint(x: 1100 + i*30, y: 80)
            bullet.zPosition = 0
            addChild(bullet)
            bullets.append(bullet)
        }
    }
    
    func hideReloadMessage() {
        reloadLabel.isHidden.toggle()
        yesLabel.isHidden.toggle()
        noLabel.isHidden.toggle()
    }
    
    func showFinalScore() {
        finalScoreLabel.isHidden = false
    }
    
    @objc func createDuck() {
        guard var duck = possibleDucks.randomElement() else { return }
        
        let duckIsTarget = Bool.random()
        
        if duckIsTarget { duck += "_target"}
        
        ducksCreated += 1
        
        let positions = [300, 450, 550]
        let row = Int.random(in: 0...2)

        let sprite = SKSpriteNode(imageNamed: duck)
        sprite.name = duckIsTarget ? "badDuck" : "goodDuck"
        sprite.position = CGPoint(x: row == 1 ? 1400 : 0, y: positions[row])
        sprite.zPosition = -3
        addChild(sprite)
        
//        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
//        sprite.physicsBody?.
//        sprite.physicsBody?.velocity = CGVector(dx: row == 1 ? -Int.random(in: 200...400) : Int.random(in: 200...400), dy: 0)
//        sprite.physicsBody?.linearDamping = 0
//        sprite.physicsBody?.angularDamping = 0
        
        let move = SKAction.moveBy(x: row == 1 ? -1500: 1500, y: 0, duration: Double.random(in: 2.0...5.0))
        let removeFromView = SKAction.run { sprite.removeFromParent() }
        let sequence = SKAction.sequence([move, removeFromView])
        
        sprite.run(sequence)
    }
    
    @objc func updateTimeLabel() {
        gameTime -= 1
        
        if gameTime <= 0 {
            isGameOver = true
        }
    }
}

