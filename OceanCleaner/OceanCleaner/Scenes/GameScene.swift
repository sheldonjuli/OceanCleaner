//
//  GameScene.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-25.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    var currentScore: Int = 5
    
    // Game over if lifeInt < 1
    private var lifeInt = 1
    private var timer = Timer()
    
    override func didMove(to view: SKView) {
        
        let gameSceneBackground = SpriteKitSceneBackground(view: view, backgroundImageName: ImageNames.gameSceneBackground)
        addChild(gameSceneBackground)
        
        // Counts every second
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startGameTimer), userInfo: nil, repeats: true)
    }
    
    @objc func startGameTimer() {
        lifeInt -= 1
        if lifeInt < 1 {
            timer.invalidate()
            sceneManagerDelegate?.presentScoreScene(currentScore: currentScore)
        }
    }
}
