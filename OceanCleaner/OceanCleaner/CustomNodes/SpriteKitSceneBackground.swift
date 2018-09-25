//
//  SpriteKitSceneBackground.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-25.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit

class SpriteKitSceneBackground: SKSpriteNode {
    
    var backgroundNode: SKSpriteNode
    
    init(view: SKView, backgroundImageName: String) {
        
        backgroundNode = SKSpriteNode(imageNamed: backgroundImageName)
        
        super.init(texture: nil, color: UIColor.clear, size: backgroundNode.size)
        
        backgroundNode = SKSpriteNode(imageNamed: backgroundImageName)
        backgroundNode.anchorPoint = ImageAnchorPoints.sceneBackground
        backgroundNode.position = view.sceneBackgroundPosition
        backgroundNode.zPosition = ZPositions.sceneBackground
        
        // Scale to fit height
        let scale = view.bounds.height / backgroundNode.size.height
        backgroundNode.yScale = scale
        backgroundNode.xScale = scale
        
        addChild(backgroundNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
