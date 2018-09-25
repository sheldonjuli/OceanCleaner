//
//  ScoreScene.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-25.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit
class ScoreScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    // Will be set by GameScene
    var currentScore: Int = 0
    
    override func didMove(to view: SKView) {
        
        saveHighestScore()
        addBackground(view: view)
        presentPopup()
    }
    
    private func saveHighestScore() {
        let userDefaults = UserDefaults.standard
        let highestScore = userDefaults.integer(forKey: "highestScore")
        
        print("Score \(currentScore)")
        print("Highest \(highestScore)")
        
        if currentScore > highestScore {
            userDefaults.set(currentScore, forKey: "highestScore")
        }
    }
    
    private func addBackground(view: SKView) {
        
        let scoreSceneBackground = SpriteKitSceneBackground(view: view, backgroundImageName: ImageNames.scoreSceneBackground)
        addChild(scoreSceneBackground)
    }
    
    private func presentPopup() {
        let popup = Popup(size: frame.size)
        popup.zPosition = ZPositions.hudBackground
        popup.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        popup.popupButtonHandlerDelegate = self
        addChild(popup)
    }
}

extension ScoreScene: PopupButtonHandlerDelegate {
    
    func homeButtonTapped() {
        sceneManagerDelegate?.presentMenuScene()
    }
    
    func retryButtonTapped() {
        sceneManagerDelegate?.presentGameScene()
    }
}
