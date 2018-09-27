//
//  GameScene.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-25.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit
import GameplayKit

enum RoundState {
    case idle, shooting, retrieving
}

class GameScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    var currentScore: Int = 5
    
    // Game over if lifeInt < 1
    private var lifeInt = 1
    private var gameTimer = Timer()
    
    let playerIconNode = SKSpriteNode(imageNamed: ImageNames.playerIcon)
    
    let lazerNode = SKSpriteNode(color: .blue, size: CGSize(width: 50.0, height: 50.0))
    
    private var roundState = RoundState.idle
    
    override func didMove(to view: SKView) {
        
        let gameSceneBackground = SpriteKitSceneBackground(view: view, backgroundImageName: ImageNames.gameSceneBackground)
        addChild(gameSceneBackground)
        
        playerIconNode.position = view.playerIconPosition
        playerIconNode.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.playerIcon)
        playerIconNode.zPosition = ZPositions.player
        addChild(playerIconNode)
        
        
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

        roundState = .shooting
        
        lazerNode.alpha = 0.5
        lazerNode.anchorPoint = AnchorPoints.lazer
        lazerNode.position = playerIconNode.position
        lazerNode.zPosition = ZPositions.lazer
        addChild(lazerNode)

        lazerNode.run(SKAction.scaleY(to: 20, duration: 1.5))
        
        print("shooting!!")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch roundState {
        case .idle:
            if touches.first != nil {
                fireLazer()
            }
        case .shooting, .retrieving:
            break
        }
    }
    
    func retrieveLazer() {
        
        roundState = .retrieving
        
        lazerNode.run(SKAction.sequence([
            SKAction.scaleY(to: 1, duration: 1.5),
            SKAction.removeFromParent()
            ]), completion: { self.roundState = .idle })
        print("shooting stopped")
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        switch roundState {
        case .shooting:
            retrieveLazer()
        case .idle, .retrieving:
            break
        }
    }

}
