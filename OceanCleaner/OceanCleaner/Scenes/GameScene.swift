//
//  GameScene.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-25.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit
import GameplayKit

enum LazerState {
    case idle, shooting, retrieving
}

class GameScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    // Score
    var currentScore: Int = 0 {
        didSet {
            currentScoreLabel.text = "\(currentScore)"
        }
    }
    private var currentScoreLabel = SKLabelNode(text: "\(0)")
    
    // Game over if no batteries left
    private var numBattery: Int = 10 {
        didSet {
            numBatteryLabel.text = "\(numBattery)"
        }
    }
    private var numBatteryLabel = SKLabelNode(text: "\(10)")
    
    // Player and lazer
    let playerIconNode = SKSpriteNode(imageNamed: ImageNames.playerIcon)
    
    private let lazerAimer = SKSpriteNode(color: .red, size: CGSize(width: 50.0, height: 20.0))
    private let lazerNode = SKSpriteNode(color: .blue, size: CGSize(width: 50.0, height: 50.0))
    
    private var lazerState = LazerState.idle
    
    override func didMove(to view: SKView) {
        
        setupPhysics()
        addGameSceneBackground(view: view)
        addPlayerNode(view: view)
        addLazer(view: view)
        
        let batteryIcon = SKSpriteNode(imageNamed: ImageNames.batteryIcon)
        batteryIcon.position = view.batteryIconPosition
        batteryIcon.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.batteryIcon)
        batteryIcon.zPosition = ZPositions.hudLabel
        addChild(batteryIcon)
        
        
        numBatteryLabel = SKLabelNode(text: "\(numBattery)")
        numBatteryLabel.fontSize = 50
        numBatteryLabel.fontColor = .black
        numBatteryLabel.position.x = view.batteryIconPosition.x - 75
        numBatteryLabel.position.y = view.batteryIconPosition.y
        numBatteryLabel.zPosition = ZPositions.hudLabel
        addChild(numBatteryLabel)
        
        
        let garbageIcon = SKSpriteNode(imageNamed: ImageNames.garbageIcon)
        garbageIcon.position = view.garbageIconPosition
        garbageIcon.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.garbageIcon)
        garbageIcon.zPosition = ZPositions.hudLabel
        addChild(garbageIcon)
        
        currentScoreLabel = SKLabelNode(text: "\(currentScore)")
        currentScoreLabel.fontSize = 50
        currentScoreLabel.fontColor = .black
        currentScoreLabel.position.x = view.garbageIconPosition.x - 75
        currentScoreLabel.position.y = view.garbageIconPosition.y
        currentScoreLabel.zPosition = ZPositions.hudLabel
        addChild(currentScoreLabel)
        
        createOceanObjects(every: 2.0)
        updateScoreAndGameState(every: 1.0)
        
    }
    
    // This method is being called every frame
    override func didSimulatePhysics() {
        
        guard let view = view else { return }
        
        // Remove out of scene objects
        for oceanObject in children {
            if oceanObject.position.x < -100 || oceanObject.position.x > view.bounds.maxX + 100 {
                oceanObject.removeFromParent()
            }
        }
    }
    
    /**
     Setup scene physics.
     */
    private func setupPhysics() {
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
    }
    
    /**
     Add gameSceneBackground to the scene.
     
     - Parameter view: used for scaling.
     */
    private func addGameSceneBackground(view: SKView) {
        
        let gameSceneBackground = SpriteKitSceneBackground(view: view, backgroundImageName: ImageNames.gameSceneBackground)
        addChild(gameSceneBackground)
        
    }
    
    /**
     Add player icon to the scene. Player icon node is used to display an image only.
     
     - Parameter view: used for scaling.
     */
    private func addPlayerNode(view: SKView) {
        
        playerIconNode.position = view.playerIconPosition
        playerIconNode.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.playerIcon)
        playerIconNode.zPosition = ZPositions.player
        addChild(playerIconNode)
        
    }
    
    /**
     Add all lazer components to the scene.
     
     - Parameter view: used for scaling.
     */
    private func addLazer(view: SKView) {
        
        lazerAimer.position = view.lazerAimerPosition
        lazerAimer.zPosition = ZPositions.lazer
        addChild(lazerAimer)
        
        let rotateLeft = SKAction.rotate(byAngle: -0.25 * .pi, duration: 1)
        let rotateRight = SKAction.rotate(byAngle: 0.25 * .pi, duration: 1)
        lazerAimer.run(SKAction.repeatForever(SKAction.sequence([
            rotateLeft,
            rotateLeft.reversed(),
            rotateRight,
            rotateRight.reversed()
            ])))
        
        lazerNode.physicsBody = SKPhysicsBody(rectangleOf: lazerNode.size)
        lazerNode.physicsBody!.categoryBitMask = PhysicsCategories.lazer
        lazerNode.physicsBody!.collisionBitMask = PhysicsCategories.none
        lazerNode.physicsBody!.contactTestBitMask = PhysicsCategories.fish | PhysicsCategories.garbage
        
    }
    
    /**
     Repetitively call updateScoreAndGameState() to update the score and game state.
     
     - Parameter second: time interval between creations.
     */
    func updateScoreAndGameState(every second: Double) {
        
        self.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run{ self.updateScoreAndGameState() },
            SKAction.wait(forDuration: second)
            ])))
        
    }
    
    func updateScoreAndGameState() {
        
        numBattery -= 1
        
        if numBattery < 1 {
            sceneManagerDelegate?.presentScoreScene(currentScore: currentScore)
        }
    }
    
    func fireLazer() {
        
        lazerState = .shooting
        
        lazerAimer.isPaused = true
        
        lazerNode.zRotation = lazerAimer.zRotation
        lazerNode.alpha = 0.5
        lazerNode.anchorPoint = AnchorPoints.lazer
        lazerNode.position = lazerAimer.position
        lazerNode.zPosition = ZPositions.lazer
        
        addChild(lazerNode)
        
        lazerNode.run(SKAction.scaleY(to: 20, duration: LazerConstant.firingTime))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch lazerState {
        case .idle:
            if touches.first != nil {
                fireLazer()
            }
        case .shooting, .retrieving:
            break
        }
    }
    
    func retrieveLazer() {
        
        lazerState = .retrieving
        
        lazerNode.run(SKAction.sequence([
            SKAction.scaleY(to: 1, duration: LazerConstant.retrivingTime),
            SKAction.removeFromParent()
            ]), completion:
            {
                self.lazerState = .idle
                self.lazerAimer.isPaused = false
        })
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch lazerState {
        case .shooting:
            retrieveLazer()
        case .idle, .retrieving:
            break
        }
    }
    
    /**
     Repetitively call createOceanObjects() to create ocean objects.
     
     - Parameter second: time interval between creations.
     */
    func createOceanObjects(every second: Double) {
        
        self.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run{ self.createOceanObjects() },
            SKAction.wait(forDuration: second)
            ])))
        
    }
    
    func createOceanObjects() {
        
        guard let view = view else { return }
        
        let numOceanObjects = randomInt(from: 2, to: 4)
        
        for _ in 0..<numOceanObjects {
            
            let oceanObject = OceanObject(level: 1)
            
            // Randomly swap at left edge or right
            let fromLeft = randomInt(from: 0, to: 1)
            oceanObject.position.x = fromLeft == 1 ? -100 : view.bounds.maxX + 100
            oceanObject.position.y = randomCGFloat(from: 10.0, to: view.bounds.maxY - 300)
            
            if oceanObject.position.x < view.bounds.midX {
                
                oceanObject.physicsBody?.velocity.dx = randomCGFloat(from: 100.0, to: 300.0)
                
                // All fish textures are facing left
                oceanObject.xScale *= -1
                
            } else {
                oceanObject.physicsBody?.velocity.dx = randomCGFloat(from: -100.0, to: -300.0)
            }
            
            addChild(oceanObject)
        }
        
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //var lazerBody = SKPhysicsBody()
        var oceanObjectBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask == PhysicsCategories.lazer {
            //lazerBody = contact.bodyA
            oceanObjectBody = contact.bodyB
        } else {
            //lazerBody = contact.bodyB
            oceanObjectBody = contact.bodyA
        }
        
        if lazerState == .shooting {
            
            retrieveLazer()
            
            let oceanObject = oceanObjectBody.node as? OceanObject
            
            oceanObject?.run(SKAction.sequence([
                SKAction.move(to: playerIconNode.position, duration: LazerConstant.retrivingTime), // Sync with lazer retrival
                SKAction.removeFromParent()
                ]))
            
            if oceanObject?.oceanObjectType == OceanObjectType.garbage {
                
                self.run(SKAction.sequence([
                    SKAction.wait(forDuration: LazerConstant.retrivingTime), // Sync with lazer retrival
                    SKAction.run{ self.numBattery += 10; self.currentScore += 1 }
                    ]))

            }
        }
    }
}
