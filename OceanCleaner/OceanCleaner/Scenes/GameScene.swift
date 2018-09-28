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
    var currentScore: Int = 0
    private var currentScoreLabel = SKLabelNode(text: "\(0)")
    
    // Game over if no batteries left
    private var numBattery = 10
    private var numBatteryLabel = SKLabelNode(text: "\(10)")
    private var gameTimer = Timer()
    
    // Player and lazer
    let playerIconNode = SKSpriteNode(imageNamed: ImageNames.playerIcon)
    
    let lazerAimer = SKSpriteNode(color: .red, size: CGSize(width: 50.0, height: 20.0))
    let lazerNode = SKSpriteNode(color: .blue, size: CGSize(width: 50.0, height: 50.0))
    
    private var lazerState = LazerState.idle
    
    // Ocean objects
    private var createOceanObjectsTimer = Timer()
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        let gameSceneBackground = SpriteKitSceneBackground(view: view, backgroundImageName: ImageNames.gameSceneBackground)
        addChild(gameSceneBackground)
        
        
        playerIconNode.position = view.playerIconPosition
        playerIconNode.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.playerIcon)
        playerIconNode.zPosition = ZPositions.player
        addChild(playerIconNode)
        
        
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
        lazerNode.physicsBody!.categoryBitMask = PhysicsCategories.Lazer
        lazerNode.physicsBody!.collisionBitMask = PhysicsCategories.none
        lazerNode.physicsBody!.contactTestBitMask = PhysicsCategories.fish | PhysicsCategories.garbage
        
        
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
        
        // Create ocean objects
        createOceanObjectsTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createOceanObjects), userInfo: nil, repeats: true)
        createOceanObjects()
        
        // Reduce 1 battery every second
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startGameTimer), userInfo: nil, repeats: true)
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
    
    @objc func startGameTimer() {
        
        numBattery -= 1
        numBatteryLabel.text = "\(numBattery)"
        
        if numBattery < 1 {
            
            gameTimer.invalidate()
            createOceanObjectsTimer.invalidate()
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
        
        lazerNode.run(SKAction.scaleY(to: 20, duration: 1))
        
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
            SKAction.scaleY(to: 1, duration: 1),
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
    
    @objc func createOceanObjects() {
        
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
