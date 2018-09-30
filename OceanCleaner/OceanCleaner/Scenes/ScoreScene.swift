//
//  ScoreScene.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-25.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit

struct PopupButton {
    static let home = 0
    static let retry = 1
}

class ScoreScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    // Will be set by GameScene
    var currentScore: Int = 0
    
    override func didMove(to view: SKView) {
        
        saveHighestScore()
        addBackground(view: view)
        addScoreBoard(view: view)
        addHomeButton(view: view)
        addRetryButton(view: view)
        
    }
    
    private func saveHighestScore() {
        
        let userDefaults = UserDefaults.standard
        let highestScoreArrayKey = "highestScoreArray"
        
        // [highest, 2nd highest, 3rd highest]
        var highestScoreArray = (userDefaults.array(forKey: highestScoreArrayKey) ?? [0, 0, 0]) as! [Int]
        
        print("Score \(currentScore)")
        print("Highest \(highestScoreArray)")
        
        for i in 0..<highestScoreArray.count {
            if currentScore > highestScoreArray[i] {
                highestScoreArray.insert(currentScore, at: i)
                highestScoreArray.removeLast()
                userDefaults.set(highestScoreArray, forKey: highestScoreArrayKey)
                break
            }
        }
        
        print("New Highest \(highestScoreArray)")
    }
    
    private func addBackground(view: SKView) {
        
        let scoreSceneBackground = SpriteKitSceneBackground(view: view, backgroundImageName: ImageNames.scoreSceneBackground)
        addChild(scoreSceneBackground)
    }
    
    private func addScoreBoard(view: SKView) {
        
        let scoreBoard = SKSpriteNode(imageNamed: ImageNames.scoreBoard)
        scoreBoard.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.scoreBoard)
        scoreBoard.position = view.scoreBoardPosition
        scoreBoard.zPosition = ZPositions.hudBackground
        
        addChild(scoreBoard)
    }
    
    private func addHomeButton(view: SKView) {
        
        let homeButton = SpriteKitButton(buttonImage: ImageNames.homeButton, action: buttonClicked, caseId: PopupButton.home)
        homeButton.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.homeButton)
        homeButton.position = view.homeButtonPosition
        homeButton.zPosition = ZPositions.hudLabel
        
        addChild(homeButton)
    }
    
    private func addRetryButton(view: SKView) {
        
        let retryButton = SpriteKitButton(buttonImage: ImageNames.retryButton, action: buttonClicked, caseId: PopupButton.retry)
        retryButton.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.retryButton)
        retryButton.position = view.retryButtonPosition
        retryButton.zPosition = ZPositions.hudLabel
        
        addChild(retryButton)
    }
    
    func buttonClicked(index: Int) {
        switch index {
        case PopupButton.home:
            sceneManagerDelegate?.presentMenuScene()
        case PopupButton.retry:
            sceneManagerDelegate?.presentGameScene()
        default:
            break
        }
    }
}
