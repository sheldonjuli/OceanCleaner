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
    private var nextSceneIndex = PopupButton.home
    
    var playInterstitialAdDelegate: PlayInterstitialAdDelegate?
    
    // Will be set by GameScene
    var currentScore: Int = 0
    
    var highestScoreArray = [0, 0, 0]
    
    override func didMove(to view: SKView) {
        
        saveHighestScore()
        
        addScoreBoard(view: view)
        addHomeButton(view: view)
        addRetryButton(view: view)
        
    }
    
    private func saveHighestScore() {
        
        let userDefaults = UserDefaults.standard
        let highestScoreArrayKey = "highestScoreArray"
        
        // [highest, 2nd highest, 3rd highest]
        highestScoreArray = userDefaults.array(forKey: highestScoreArrayKey) as? [Int] ?? highestScoreArray
        
        for i in 0..<highestScoreArray.count {
            if currentScore > highestScoreArray[i] {
                highestScoreArray.insert(currentScore, at: i)
                highestScoreArray.removeLast()
                userDefaults.set(highestScoreArray, forKey: highestScoreArrayKey)
                break
            }
        }
    }
    
    private func addScoreBoard(view: SKView) {
        
        let scoreBoard = SKSpriteNode(imageNamed: ImageNames.scoreBoard)
        scoreBoard.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: AspectScaleMultiplier.scoreBoard)
        scoreBoard.position = view.scoreBoardPosition
        scoreBoard.zPosition = ZPositions.hudBackground
 
        let sectionHeight = 0.75  * scoreBoard.size.height / 4
        
        // Add the new score in the loop as well
        for i in 0...highestScoreArray.count {
            
            let scoreNode = SKLabelNode(text: "")
            if i == highestScoreArray.count {
                scoreNode.text = "New. \(currentScore)"
            } else {
                scoreNode.text = "\(i+1). \(highestScoreArray[i])"
            }
            
            scoreNode.fontName = "ChalkboardSE-Bold"
            scoreNode.fontSize = sectionHeight * 0.5
            scoreNode.fontColor = .white
            scoreNode.position.x = scoreBoard.frame.midX
            scoreNode.position.y = scoreBoard.frame.maxY * 0.95 - sectionHeight * CGFloat(i+1)
            scoreNode.zPosition = ZPositions.hudLabel
            addChild(scoreNode)
        }

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
    
    func buttonClicked(sceneIndex: Int) {
        
        nextSceneIndex = sceneIndex
        
        // Play an interstitialAd first
        // If an ad is being played, present scene only after the ad has been closed
        // GameViewController.interstitialDidDismissScreen() will handle this case
        if checkIfInterstitialAdAvailable() {
            playInterstitialAdDelegate?.playInterstitialAd()
        } else {
            presentScene()
        }
        
    }
    
    func presentScene() {
        
        switch nextSceneIndex {
        case PopupButton.home:
            sceneManagerDelegate?.presentMenuScene()
        case PopupButton.retry:
            sceneManagerDelegate?.presentGameScene()
        default:
            break
        }
        
    }
    
    private func checkIfInterstitialAdAvailable() -> Bool {
        
        return playInterstitialAdDelegate?.checkIfInterstitialAdAvailable() ?? false
        
    }
}
