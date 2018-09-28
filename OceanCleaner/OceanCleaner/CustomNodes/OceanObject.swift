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
}

enum GarbageTypes: String {
    case shoe = "shoe"
    case can = "can"
}

/**
 A SKSpriteNode which captures all properties of an ocean object.
 */
class OceanObject: SKSpriteNode {
    
    let fishes = [FishTypes.clown, .balloon]
    let garbages = [GarbageTypes.shoe, .can]
    
    var oceanObjectType: OceanObjectType
    
    /**
     Initializes an OceanObject.
     
     - Parameter level: will be used to determine the swap rate of different types of objects.
     */
    init(level: Int) {
        
        let oceanObjectSize = CGSize(width: 50.0, height: 50.0)
        
        var imageName = ""
        
        let threshold = CGFloat(level) / 5 + 0.5
        if randomCGFloat(from: 0, to: 1) < threshold {
            oceanObjectType = .fish
            let randomIndex = randomInt(from: 0, to: fishes.count - 1)
            imageName = fishes[randomIndex].rawValue
        } else {
            oceanObjectType = .garbage
            let randomIndex = randomInt(from: 0, to: garbages.count - 1)
            imageName = garbages[randomIndex].rawValue
        }
        
        let oceanObjectNode = SKSpriteNode(imageNamed: imageName)
        
        // TODO: different objects will have different sizes
        oceanObjectNode.size = CGSize(width: 70.0, height: 50.0)
        oceanObjectNode.zPosition = ZPositions.oceanObject
        
        super.init(texture: nil, color: .clear, size: oceanObjectSize)
        
        physicsBody = SKPhysicsBody(rectangleOf: oceanObjectNode.size)
        physicsBody!.categoryBitMask = oceanObjectType == .fish ? PhysicsCategories.fish : PhysicsCategories.garbage
        physicsBody!.collisionBitMask = PhysicsCategories.none
        physicsBody!.contactTestBitMask = PhysicsCategories.lazer
        
        addChild(oceanObjectNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
