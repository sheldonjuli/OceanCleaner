//
//  GameViewController.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-25.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import StoreKit

protocol SceneManagerDelegate {
    func presentMenuScene()
    func presentGameScene()
    func presentScoreScene(currentScore: Int)
}

class GameViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentMenuScene()
        addGADBanner()
        addRewardBasedAd()
    }
}

extension GameViewController: SceneManagerDelegate {
    
    func presentMenuScene() {
        let menuScene = MenuScene(size: view.bounds.size)
        menuScene.sceneManagerDelegate = self
        present(scene: menuScene)
    }
    
    func presentGameScene() {
        let gameScene = GameScene(size: view.bounds.size)
        gameScene.sceneManagerDelegate = self
        present(scene: gameScene)
    }
    
    func presentScoreScene(currentScore: Int) {
        let scoreScene = ScoreScene(size: view.bounds.size)
        scoreScene.currentScore = currentScore
        scoreScene.sceneManagerDelegate = self
        present(scene: scoreScene)
    }
    
    func present(scene: SKScene) {
        
        if let view = self.view as! SKView? {
            
            // Make sure we start with a fresh scene
            if let gestureRecognizers = view.gestureRecognizers {
                for recognizer in gestureRecognizers {
                    view.removeGestureRecognizer(recognizer)
                }
            }
            
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            
            // Debug code
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }
}

extension GameViewController: GADBannerViewDelegate {
    
    func addGADBanner() {
        let BannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        BannerView.isHidden = true
        let bannerHeight:CGFloat = 50.0
        BannerView.frame = CGRect(x: 0, y: view.bounds.maxY - bannerHeight, width: view.bounds.maxX, height: bannerHeight)
        BannerView.delegate = self
        BannerView.adUnitID = GoogleAdmobValues.BannerAdUnitID
        BannerView.rootViewController = self
        BannerView.load(GADRequest())
        BannerView.backgroundColor = UIColor.black
        view.addSubview(BannerView)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner is receiving ads.")
        bannerView.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
        bannerView.isHidden = true
    }
}

extension GameViewController: GADRewardBasedVideoAdDelegate {
    
    func addRewardBasedAd() {
        let rewardBasedAd = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedAd.delegate = self
        rewardBasedAd.load(GADRequest(), withAdUnitID: GoogleAdmobValues.RewardAdUnitID)
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad has completed.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
    }
    
}
