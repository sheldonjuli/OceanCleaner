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
    
    var playRewardAdDelegate: PlayRewardAdDelegate?
    
    var isGamePaused = false
    
    var playVideoButton: SpriteKitButton?
    var cancelButton: SpriteKitButton?
    
    // Score
    var currentScore: Int = 0 {
        didSet {
            currentScoreLabel.text = "\(currentScore)"
        }
    }
    private var currentScoreLabel = SKLabelNode(text: "\(0)")
    
    private var isSecondLife = false
    
    // Game over if no batteries left
    private var numBattery: Int = 10 {
        didSet {
            numBatteryLabel.text = "\(numBattery)"
        }
    }
    private var numBatteryLabel = SKLabelNode(text: "\(10)")
    
    // Player and lazer
    let playerIconNode = SKSpriteNode(imageNamed: ImageNames.playerIcon)
    
    private let lazer = SKSpriteNode(imageNamed: ImageNames.lazer)
    
    private var lazerRotation: SKAction {
        return SKAction().rotateLeftAndRightForever(by: 0.6, duration: 1)
    }
    
    private var lazerState = LazerState.idle
    
    // Scene animations
    private var bubbles = [Bubble]()
    
    override func didMove(to view: SKView) {
        
        setupPhysics()
        addGameSceneBackground(view: view)
        addPlayerNode(view: view)
        addLazer(view: view)
        addHudLabels(view: view)
        
        animateBubble(every: 0.2)
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
        
        lazer.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.lazer)
        lazer.anchorPoint = AnchorPoints.lazer
        lazer.position = view.lazerPosition
        lazer.zPosition = ZPositions.lazer
        addChild(lazer)
        
        lazer.run(lazerRotation)
        
        // The height is adjusted to accommodate anchor point
        let adjustedSize = CGSize(width: lazer.size.width / 2, height: lazer.size.height * 1.8)
        lazer.physicsBody = SKPhysicsBody(rectangleOf: adjustedSize)
        lazer.physicsBody!.categoryBitMask = PhysicsCategories.lazer
        lazer.physicsBody!.collisionBitMask = PhysicsCategories.none
        lazer.physicsBody!.contactTestBitMask = PhysicsCategories.fish | PhysicsCategories.garbage
        
    }
    
    /**
     Add all battery icon and label to the scene.
     
     - Parameter view: used for scaling.
     */
    private func addHudLabels(view: SKView) {
        
        let labelFontName = "ChalkboardSE-Bold"
        
        let batteryIcon = SKSpriteNode(imageNamed: ImageNames.batteryIcon)
        batteryIcon.position = view.batteryIconPosition
        batteryIcon.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.batteryIcon)
        batteryIcon.zPosition = ZPositions.hudLabel
        addChild(batteryIcon)
        
        let labelTextOffsetX = batteryIcon.size.width * 1
        let labelTextOffsetY = batteryIcon.size.height * 0.4
        let labelFontSize = batteryIcon.size.height
        
        numBatteryLabel = SKLabelNode(text: "\(numBattery)")
        numBatteryLabel.fontName = labelFontName
        numBatteryLabel.fontSize = labelFontSize
        numBatteryLabel.fontColor = .white
        numBatteryLabel.position.x = view.batteryIconPosition.x - labelTextOffsetX
        numBatteryLabel.position.y = view.batteryIconPosition.y - labelTextOffsetY
        numBatteryLabel.zPosition = ZPositions.hudLabel
        addChild(numBatteryLabel)
        
        
        let garbageIcon = SKSpriteNode(imageNamed: ImageNames.garbageIcon)
        garbageIcon.position = view.garbageIconPosition
        garbageIcon.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.garbageIcon)
        garbageIcon.zPosition = ZPositions.hudLabel
        addChild(garbageIcon)
        
        currentScoreLabel = SKLabelNode(text: "\(currentScore)")
        currentScoreLabel.fontName = labelFontName
        currentScoreLabel.fontSize = labelFontSize
        currentScoreLabel.fontColor = .white
        currentScoreLabel.position.x = view.garbageIconPosition.x - labelTextOffsetX
        currentScoreLabel.position.y = view.garbageIconPosition.y - labelTextOffsetY
        currentScoreLabel.zPosition = ZPositions.hudLabel
        addChild(currentScoreLabel)
        
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
        
        if !isGamePaused {
            numBattery -= 1
            
            if numBattery < 1 {
                
                if isSecondLife {
                    presentScoreScene(CommonValue.dontCare)
                } else {
                    presentGetSecondLifePopup()
                }
            }
        }
    }
    
    private func presentGetSecondLifePopup() {
        
        guard let view = self.view else { return }
        
        // Pause game
        isGamePaused = true
        self.isUserInteractionEnabled = false
        
        playVideoButton = SpriteKitButton(buttonImage: ImageNames.noAdsButton, action: playRewardAds, caseId: 0)
        playVideoButton?.position = view.playRewardAdsButtonPosition
        playVideoButton?.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.playRewardAdsButton)
        playVideoButton?.zPosition = ZPositions.hudLabel
        addChild(playVideoButton!)
        
        cancelButton = SpriteKitButton(buttonImage: ImageNames.cancelButton, action: presentScoreScene, caseId: CommonValue.dontCare)
        cancelButton?.position = view.cancelButtonPosition
        cancelButton?.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.cancelButton)
        cancelButton?.zPosition = ZPositions.hudLabel
        addChild(cancelButton!)
        
        
        if !checkIfRewardAdAvailable() {
            playVideoButton?.isUserInteractionEnabled = false
            playVideoButton?.alpha = 0.5
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: RewardAdConstant.adNotAvailableWaitTime),
                SKAction.run{ self.presentScoreScene(CommonValue.dontCare) }
                ]))
        }
    }
    
    private func presentScoreScene(_: Int) {
        
        sceneManagerDelegate?.presentScoreScene(currentScore: currentScore)
        
    }
    
    private func checkIfRewardAdAvailable() -> Bool {
        
        return playRewardAdDelegate?.checkIfRewardAdAvailable() ?? false
        
    }
    
    
    private func playRewardAds(_: Int) {
        
        playRewardAdDelegate?.playRewardAd()
        
    }
    
    func rewardUserForWatchingAd() {
        
        numBattery += 10
        self.isUserInteractionEnabled = true
        isGamePaused = false
        isSecondLife = true
        playVideoButton?.removeFromParent()
        cancelButton?.removeFromParent()
        
    }
    
    func fireLazer() {
        
        lazerState = .shooting
        lazer.removeAllActions()
        lazer.run(SKAction.scaleY(to: LazerConstant.maxScaleY, duration: LazerConstant.firingTime))
        
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
    
    private func getLazerRetrieveTime() -> Double {
        
        let lazerScaleY = lazer.yScale
        return Double(lazerScaleY / LazerConstant.maxScaleY) * LazerConstant.firingTime
        
    }
    
    func retrieveLazer() {
        
        lazerState = .retrieving
        lazer.removeAllActions()
        
        let retriveDuration = getLazerRetrieveTime()
        let rotatedAngle = lazer.zRotation
        let rotateBackDuration = TimeInterval(abs(2 * rotatedAngle / .pi))
        
        // Scale back to the original size, set at 0.5 so the physics works properly
        let adjustedOriginalScale = CGFloat(0.5)
        
        lazer.run(SKAction.sequence([
            SKAction.scaleY(to: adjustedOriginalScale, duration: retriveDuration),
            SKAction.rotate(byAngle: -rotatedAngle, duration: rotateBackDuration)
            ]), completion:
            {
                self.lazerState = .idle
                if rotatedAngle < 0 {
                    self.lazer.run(self.lazerRotation.reversed())
                } else {
                    self.lazer.run(self.lazerRotation)
                }
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
        
        guard let view = view else { return }
        
        self.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run{
                let numOceanObjects = randomInt(from: 2, to: 4)
                for _ in 0..<numOceanObjects {
                    self.addChild(OceanObject(level: 1, view: view))
                }},
            SKAction.wait(forDuration: second)
            ])))
    }
    
    /**
     Add and animate bubbles every given second.
     
     - Parameter second: time interval between creations.
     */
    func animateBubble(every second: Double) {
        
        self.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run{ self.addBubbles(); self.floatBubbles() },
            SKAction.wait(forDuration: second)
            ])))
        
    }
    
    func addBubbles() {
        addBubble(on: BubbleLayer.one, at: CGPoint(x: 100, y: 100))
        addBubble(on: BubbleLayer.one, at: CGPoint(x: 500, y: 100))
        addBubble(on: BubbleLayer.two, at: CGPoint(x: 200, y: 200))
        addBubble(on: BubbleLayer.two, at: CGPoint(x: 350, y: 200))
    }
    
    func addBubble(on layer: BubbleLayer, at position: CGPoint) {
        let bubble = Bubble(on: layer)
        bubble.position = position
        bubbles.append(bubble)
        addChild(bubble)
    }
    
    func floatBubbles() {
        for bubble in bubbles {
            
            let xOffset: CGFloat = CGFloat(arc4random_uniform(20)) - 10.0
            let yOffset: CGFloat = 20.0
            let newLocation = CGPoint(x: bubble.position.x + xOffset, y: bubble.position.y + yOffset)
            let moveAction = SKAction.move(to: newLocation, duration: 0.2)
            bubble.run(moveAction)
            
            bubble.lifeRemain -= 1
            
            if bubble.lifeRemain < 1 {
                bubble.removeFromParent()
                
                if let index = bubbles.index(of: bubble) {
                    bubbles.remove(at: index)
                }
            }
            
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
            
            let retriveDuration = getLazerRetrieveTime()
            
            let oceanObject = oceanObjectBody.node as? OceanObject
            
            // Sync with lazer retrival
            let moveAction = SKAction.move(to: playerIconNode.position, duration: retriveDuration)
            let shrinkAction = SKAction.scale(to: 0.1, duration: retriveDuration)
            let rotateAction = SKAction.repeatForever(SKAction.rotate(byAngle: 2 * .pi, duration: retriveDuration))
            let shrinkAndMoveAndRotate = SKAction.group([moveAction, shrinkAction, rotateAction])
            
            oceanObject?.run(SKAction.sequence([
                shrinkAndMoveAndRotate,
                SKAction.removeFromParent()
                ]))
            
            if oceanObject?.oceanObjectType == OceanObjectType.garbage {
                
                self.run(SKAction.sequence([
                    SKAction.wait(forDuration: retriveDuration), // Sync with lazer retrival
                    SKAction.run{ self.numBattery += 10; self.currentScore += 1 }
                    ]))
                
            }
        }
    }
}
