//
//  SpriteKitSceneBackground.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-25.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit

/**
 A SKSpriteNode which holds the background of a scene.
 */
class SpriteKitSceneBackground: SKSpriteNode {
    
    var backgroundNode: SKSpriteNode
    
    /**
     Initializes a SpriteKitSceneBackground.
     
     - Parameter view: The view we are trying to add to. Used for image scaling.
     - Parameter backgroundImageName: The name of the background image.
     */
    init(view: SKView) {
        
        backgroundNode = SKSpriteNode(imageNamed: ImageNames.sceneBackground)
        
        super.init(texture: nil, color: UIColor.clear, size: backgroundNode.size)
        
        backgroundNode.anchorPoint = AnchorPoints.sceneBackground
        backgroundNode.position = view.sceneBackgroundPosition
        backgroundNode.zPosition = ZPositions.sceneBackground
        
        // Scale to fit height
        let bgScale = view.bounds.height / backgroundNode.size.height
        backgroundNode.yScale = bgScale
        backgroundNode.xScale = bgScale
        
        addChild(backgroundNode)
        
        // Scene Decorations
        let wave1 = SKSpriteNode(imageNamed: ImageNames.wave1)
        wave1.anchorPoint = AnchorPoints.sceneBackground
        wave1.position = CGPoint(x: view.bounds.maxX * 0.5, y: view.bounds.maxY * 0.7)
        wave1.zPosition = ZPositions.sceneBackgroundDeco
        
        let wave2 = SKSpriteNode(imageNamed: ImageNames.wave2)
        wave2.anchorPoint = AnchorPoints.sceneBackground
        wave2.position = CGPoint(x: view.bounds.maxX * 0.5, y: view.bounds.maxY * 0.7)
        wave2.zPosition = ZPositions.sceneBackgroundDeco
        wave2.alpha = 0

        // Scale to fit height
        let waveScale = 1.35 * view.bounds.width / wave1.size.width
        wave1.yScale = waveScale
        wave1.xScale = waveScale
        wave2.yScale = waveScale
        wave2.xScale = waveScale

        addChild(wave1)
        addChild(wave2)
        
        self.run(SKAction.sequence([
            SKAction.run { wave1.run(SKAction().fadeInAndOutForever(isFadeInFirst: false, duration: 1.5)) },
            SKAction.run { wave2.run(SKAction().fadeInAndOutForever(isFadeInFirst: true, duration: 1.5)) }
            ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
