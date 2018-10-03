//
//  OceanObjects.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-27.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit

enum OceanObjectType {
    case fish
    case garbage
}

enum FishTypes: String {
    case clown = "clown"
    case balloon = "balloon"
    case red = "red"
    case grey = "grey"
}

enum GarbageTypes: String {
    case shoe = "shoe"
    case can = "can"
    case plasticBag = "plasticBag"
}

/**
 A SKSpriteNode which captures all properties of an ocean object.
 */
class OceanObject: SKSpriteNode {
    
    let fishes = [FishTypes.red, .grey]
    let garbages = [GarbageTypes.shoe, .can, .plasticBag]
    
    var oceanObjectType: OceanObjectType
    
    /**
     Initializes an OceanObject.
     
     - Parameter level: will be used to determine the swap rate of different types of objects.
     */
    init(level: Int, view: SKView) {
        
        let oceanObjectSize = CGSize(width: 50.0, height: 50.0)
        
        var imageName = ""
        var aspectScaleMultiplier = CGFloat(0.0)
        
        let threshold = CGFloat(level) / 5 + 0.5
        if randomCGFloat(from: 0, to: 1) < threshold {
            oceanObjectType = .fish
            let randomIndex = randomInt(from: 0, to: fishes.count - 1)
            imageName = fishes[randomIndex].rawValue
            aspectScaleMultiplier = AspectScaleMultiplier.fish
        } else {
            oceanObjectType = .garbage
            let randomIndex = randomInt(from: 0, to: garbages.count - 1)
            imageName = garbages[randomIndex].rawValue
            aspectScaleMultiplier = AspectScaleMultiplier.garbage
        }
        
        let oceanObjectNode = SKSpriteNode(imageNamed: imageName)
        
        // TODO: different objects will have different sizes
        oceanObjectNode.aspectScale(to: view.bounds.size, regardingWidth: true, multiplier: aspectScaleMultiplier)
        oceanObjectNode.zPosition = ZPositions.oceanObject
        
        super.init(texture: nil, color: .clear, size: oceanObjectSize)
        
        oceanObjectNode.run(SKAction().rotateLeftAndRightForever(by: 0.015, duration: 0.1))
        
        physicsBody = SKPhysicsBody(rectangleOf: oceanObjectNode.size)
        physicsBody!.categoryBitMask = oceanObjectType == .fish ? PhysicsCategories.fish : PhysicsCategories.garbage
        physicsBody!.collisionBitMask = PhysicsCategories.none
        physicsBody!.contactTestBitMask = PhysicsCategories.lazer
        
        // Randomly swap at left edge or right
        let fromLeft = randomInt(from: 0, to: 1)
        position.x = fromLeft == 1 ? -100 : view.bounds.maxX + 100
        position.y = randomCGFloat(from: 50.0, to: view.bounds.maxY - 300)
        
        let lowerSpeed = view.bounds.width / 4
        let higherSpeed = view.bounds.width / 2
        
        if position.x < view.bounds.midX {
            
            // All fish textures are facing left
            xScale *= -1
            physicsBody!.velocity.dx = randomCGFloat(from: lowerSpeed, to: higherSpeed)
            
        } else {
            physicsBody!.velocity.dx = randomCGFloat(from: -lowerSpeed, to: -higherSpeed)
        }
        
        addChild(oceanObjectNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
