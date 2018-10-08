//
//  Cloud.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-10-07.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit

class Cloud: SKSpriteNode {
    
    /**
     Initializes a Cloud object.
     
     - Parameter view: The view we are adding it in.
     */
    init(in view: SKView) {
        
        let cloud = SKSpriteNode(imageNamed: ImageNames.cloud)
        
        let aspectScaleMultiplier = CGFloat(randomCGFloat(from: 0.1, to: 0.25))
        cloud.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: aspectScaleMultiplier)
        
        if aspectScaleMultiplier < 0.2 {
            // "Far away cloud", don't block playerIcon
            cloud.zPosition = ZPositions.sceneBackgroundDeco
        } else {
            // "Close up cloud", block playerIcon
            cloud.zPosition = ZPositions.player + 1
        }
        
        super.init(texture: nil, color: .clear, size: cloud.size)
        
        physicsBody = SKPhysicsBody(rectangleOf: cloud.size)
        physicsBody!.contactTestBitMask = PhysicsCategories.none
        physicsBody!.collisionBitMask = PhysicsCategories.none
        
        position.x = -100
        position.y = randomCGFloat(from: view.bounds.maxY * 0.8, to: view.bounds.maxY * 0.9)
        
        let lowerSpeed = view.bounds.width / 10
        let higherSpeed = view.bounds.width / 5
        physicsBody!.velocity.dx = randomCGFloat(from: lowerSpeed, to: higherSpeed)
        
        addChild(cloud)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
