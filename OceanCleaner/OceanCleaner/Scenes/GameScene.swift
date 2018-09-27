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
    
    var currentScore: Int = 5
    
    // Game over if lifeInt < 1
    private var lifeInt = 1
    private var gameTimer = Timer()
    
    let playerIconNode = SKSpriteNode(imageNamed: ImageNames.playerIcon)
    
    let lazerAimer = SKSpriteNode(color: .red, size: CGSize(width: 50.0, height: 20.0))
    let lazerNode = SKSpriteNode(color: .blue, size: CGSize(width: 50.0, height: 50.0))
    
    private var lazerState = LazerState.idle
    
    override func didMove(to view: SKView) {
        
        let gameSceneBackground = SpriteKitSceneBackground(view: view, backgroundImageName: ImageNames.gameSceneBackground)
        addChild(gameSceneBackground)
        
        
        playerIconNode.position = view.playerIconPosition
        playerIconNode.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.playerIcon)
        playerIconNode.zPosition = ZPositions.player
        addChild(playerIconNode)
        
        
        lazerAimer.position = view.lazerAimerPosition
        lazerAimer.zPosition = ZPositions.lazer
        addChild(lazerAimer)
        
        let rotateLeft = SKAction.rotate(byAngle: -0.25 * .pi, duration: 2)
        let rotateRight = SKAction.rotate(byAngle: 0.25 * .pi, duration: 2)
        lazerAimer.run(SKAction.repeatForever(SKAction.sequence([
            rotateLeft,
            rotateLeft.reversed(),
            rotateRight,
            rotateRight.reversed()
            ])))
        
        
        let batteryIcon = SKSpriteNode(imageNamed: ImageNames.batteryIcon)
        batteryIcon.position = view.batteryIconPosition
        batteryIcon.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.batteryIcon)
        batteryIcon.zPosition = ZPositions.hudLabel
        addChild(batteryIcon)
        
        // Counts every second
        gameTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(startGameTimer), userInfo: nil, repeats: true)
    }
    
    @objc func startGameTimer() {
        lifeInt -= 1
        if lifeInt < 1 {
            gameTimer.invalidate()
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
        
        lazerNode.run(SKAction.scaleY(to: 20, duration: 1.5))
        
        print("shooting!!")
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
            SKAction.scaleY(to: 1, duration: 1.5),
            SKAction.removeFromParent()
            ]), completion:
            {
                self.lazerState = .idle
                self.lazerAimer.isPaused = false
        })
        
        print("shooting stopped")
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch lazerState {
        case .shooting:
            retrieveLazer()
        case .idle, .retrieving:
            break
        }
    }
    
}
