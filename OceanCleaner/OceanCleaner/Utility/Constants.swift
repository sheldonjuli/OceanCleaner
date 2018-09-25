//
//  Constants.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-25.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit

struct ImageNames {
    static let menuSceneBackground = "menuSceneBackground"
    static let gameSceneBackground = "gameSceneBackground"
    static let scoreSceneBackground = "scoreSceneBackground"
    
    static let startButton = "startButton"
    static let homeButton = "homeButton"
    static let retryButton = "retryButton"
    static let noAdsButton = "noAdsButton"
}

struct ImageAnchorPoints {
    static let sceneBackground = CGPoint(x: 0.5, y: 0.5)
}

struct ImagePositions {
    static let sceneBackground = CGPoint.zero
}

struct ZPositions {
    static let sceneBackground: CGFloat = 1
    
    // hud elements should have the highest priorities
    static let hudBackground: CGFloat = 10
    static let hudLabel: CGFloat = 11
}

struct AspectScaleMultiplier {
    // Relative to parent size
    static let popup: CGFloat = 0.5
    
    static let startButton: CGFloat = 0.2
    static let homeButton: CGFloat = 0.3
    static let retryButton: CGFloat = 0.3
    static let noAdsButton: CGFloat = 0.2
}

struct GADValues {
    static let adUnitID = ""
}

struct InAppPurchases {
    static let productId = ""
}

extension SKView {
    
    var startButtonPosition: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY * 0.8)
    }
    
    var noAdsButtonPosition: CGPoint {
        return CGPoint(x: bounds.maxX - 100, y: bounds.maxY - 100)
    }
}
