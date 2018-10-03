//
//  Constants.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-25.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit

struct CommonValue {
    static let dontCare = 0
}

struct ImageNames {
    
    // Menu Scene
    static let menuSceneBackground = "menuSceneBackground"
    static let noAdsButton = "noAdsButton"
    static let tapToStartImg = "tapToStartImg"
    
    // Game Scene
    static let gameSceneBackground = "gameSceneBackground"
    static let playerIcon = "playerIcon"
    static let lazer = "lazer"
    static let batteryIcon = "batteryIcon"
    static let garbageIcon = "garbageIcon"
    static let cancelButton = "cancelButton"
    
    // Score Scene
    static let scoreSceneBackground = "scoreSceneBackground"
    static let scoreBoard = "scoreBoard"
    static let homeButton = "homeButton"
    static let retryButton = "retryButton"
    
}

struct AnchorPoints {
    static let sceneBackground = CGPoint(x: 0.5, y: 0.5)
    
    // Scaling Y only stretches it downwards
    static let lazer = CGPoint(x: 0.5, y: 1.0)
}

struct ImagePositions {
    static let sceneBackground = CGPoint.zero
}

struct ZPositions {
    static let sceneBackground: CGFloat = 1
    
    // hud elements should have the highest priorities
    static let hudBackground: CGFloat = 10
    static let hudLabel: CGFloat = 11
    
    static let oceanObject: CGFloat = 18
    static let lazer: CGFloat = 19
    static let player: CGFloat = 20
}

// Relative to parent size
struct AspectScaleMultiplier {
    static let popup: CGFloat = 0.75
    
    // Menu Scene
    static let tapToStartImg: CGFloat = 0.2
    static let noAdsButton: CGFloat = 0.1
    
    // Game Scene
    static let playerIcon: CGFloat = 0.2
    static let lazer: CGFloat = 0.1
    static let batteryIcon: CGFloat = 0.09
    static let garbageIcon: CGFloat = 0.1
    static let playRewardAdsButton: CGFloat = 0.1
    static let cancelButton: CGFloat = 0.1
    
    static let fish: CGFloat = 0.1
    static let garbage: CGFloat = 0.075
    
    // Score Scene
    static let scoreBoard: CGFloat = 0.75
    static let homeButton: CGFloat = 0.1
    static let retryButton: CGFloat = 0.1
}

struct GoogleAdmobValues {
    
    static let bannerAdUnitID = "ca-app-pub-3910607987474251/9986271397"
    
    static let rewardAdUnitID = "ca-app-pub-3910607987474251/9989563835"
    
    static let interstitialAdUnitID = "ca-app-pub-3910607987474251/6122433022"
    
}

struct InAppPurchases {
    static let productId = ""
}

struct PhysicsCategories {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let lazer: UInt32 = 0x1 << 1
    static let fish: UInt32 = 0x1 << 2
    static let garbage: UInt32 = 0x1 << 3
}

struct LazerConstant {
    
    static let maxScaleY: CGFloat = 15.0
    static let firingTime: Double = 1.0
    
}

struct RewardAdConstant {
    static let adAvailableWaitTime = 5.0
    static let adNotAvailableWaitTime = 3.0
}

extension SKView {
    
    var sceneBackgroundPosition: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    // Menu Scene
    
    var tapToStartImgPosition: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    var noAdsButtonPosition: CGPoint {
        return CGPoint(x: bounds.maxX * 0.9, y: bounds.maxY * 0.9)
    }
    
    // Game Scene
    
    var playerIconPosition: CGPoint {
        return CGPoint(x: bounds.maxX * 0.5, y: bounds.maxY * 0.9)
    }
    
    var lazerPosition: CGPoint {
        return CGPoint(x: bounds.maxX * 0.5, y: bounds.maxY * 0.9)
    }
    
    var batteryIconPosition: CGPoint {
        return CGPoint(x: bounds.maxX * 0.9, y: bounds.maxY * 0.925)
    }
    
    var garbageIconPosition: CGPoint {
        return CGPoint(x: bounds.maxX * 0.9, y: bounds.maxY * 0.85)
    }
    
    var playRewardAdsButtonPosition: CGPoint {
        return CGPoint(x: bounds.maxX * 0.5, y: bounds.maxY * 0.5)
    }
    
    var cancelButtonPosition: CGPoint {
        return CGPoint(x: bounds.maxX * 0.5, y: bounds.maxY * 0.4)
    }
    
    // Score Scene
    
    var scoreBoardPosition: CGPoint {
        return CGPoint(x: bounds.maxX * 0.5, y: bounds.maxY * 0.6)
    }
    
    var homeButtonPosition: CGPoint {
        return CGPoint(x: bounds.maxX * 0.3, y: bounds.maxY * 0.3)
    }
    
    var retryButtonPosition: CGPoint {
        return CGPoint(x: bounds.maxX * 0.7, y: bounds.maxY * 0.3)
    }
}
