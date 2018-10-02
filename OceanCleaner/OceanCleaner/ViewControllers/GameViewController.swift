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

protocol PlayRewardAdDelegate {
    func playRewardAd()
    func checkIfRewardAdAvailable() -> Bool
}

protocol PlayInterstitialAdDelegate {
    func playInterstitialAd()
    func checkIfInterstitialAdAvailable() -> Bool
}

class GameViewController: UIViewController {
    
    var rewardBasedAd: GADRewardBasedVideoAd!
    var interstitialAd: GADInterstitial!
    
    var gameScene: GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentMenuScene()
        addGADBanner()
        rewardBasedAd = createAndLoadRewardBasedAd()
        interstitialAd = createAndLoadInterstitial()
    }
    
}

extension GameViewController: SceneManagerDelegate {
    
    func presentMenuScene() {
        let menuScene = MenuScene(size: view.bounds.size)
        menuScene.sceneManagerDelegate = self
        present(scene: menuScene)
    }
    
    func presentGameScene() {
        gameScene = GameScene(size: view.bounds.size)
        gameScene?.sceneManagerDelegate = self
        gameScene?.playRewardAdDelegate = self
        present(scene: gameScene!)
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
        BannerView.adUnitID = GoogleAdmobValues.bannerAdUnitID
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

extension GameViewController: GADRewardBasedVideoAdDelegate, PlayRewardAdDelegate {
    
    func checkIfRewardAdAvailable() -> Bool {
        return rewardBasedAd.isReady
    }
    
    func playRewardAd() {
        if checkIfRewardAdAvailable() {
            rewardBasedAd.present(fromRootViewController: self)
        }
    }
    
    func createAndLoadRewardBasedAd() -> GADRewardBasedVideoAd {
        let rewardBasedAd = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedAd.delegate = self
        let request = GADRequest()
        
        // TDOD remove test code
        request.testDevices = [ "b90d517bbd126ad43c612357a349ee23" ]
        rewardBasedAd.load(request, withAdUnitID: GoogleAdmobValues.rewardAdUnitID)
        return rewardBasedAd
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        
        gameScene?.rewardUserForWatchingAd()
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
        rewardBasedAd = createAndLoadRewardBasedAd()
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
    }
    
}

extension GameViewController: GADInterstitialDelegate, PlayInterstitialAdDelegate {
    
    func checkIfInterstitialAdAvailable() -> Bool {
        return interstitialAd.isReady
    }
    
    func playInterstitialAd() {
        if checkIfInterstitialAdAvailable() {
            interstitialAd.present(fromRootViewController: self)
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitialAd = GADInterstitial(adUnitID: GoogleAdmobValues.interstitialAdUnitID)
        interstitialAd.delegate = self
        let request = GADRequest()
        
        // TDOD remove test code
        request.testDevices = [ "b90d517bbd126ad43c612357a349ee23" ]
        interstitialAd.load(request)
        return interstitialAd
    }
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        interstitialAd = createAndLoadInterstitial()
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
    
}
