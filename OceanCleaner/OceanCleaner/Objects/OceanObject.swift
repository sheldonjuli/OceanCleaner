//
//  OceanObjects.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-27.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit

enum OceanObjectTypes {
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

class OceanObject: SKSpriteNode {
    
    let fishes = [FishTypes.clown, .balloon]
    let garbages = [GarbageTypes.shoe, .can]

    var oceanObjectType: OceanObjectTypes
    
    init(level: Int) {
        
        var oceanObjectNode: SKSpriteNode
        let oceanObjectSize = CGSize(width: 50.0, height: 50.0)

        let threshold = CGFloat(level) / 5 + 0.5
        if randomCGFloat(from: 0, to: 1) < threshold {
            
            oceanObjectType = OceanObjectTypes.fish
            let randomIndex = randomInt(from: 0, to: fishes.count - 1)
            oceanObjectNode = SKSpriteNode(imageNamed: fishes[randomIndex].rawValue)
            
            // TODO: different objects will have different sizes
            oceanObjectNode.size = CGSize(width: 70.0, height: 50.0)

        } else {
            
            oceanObjectType = OceanObjectTypes.garbage
            let randomIndex = randomInt(from: 0, to: garbages.count - 1)
            oceanObjectNode = SKSpriteNode(imageNamed: garbages[randomIndex].rawValue)
            
            // TODO: different objects will have different sizes
            oceanObjectNode.size = CGSize(width: 70.0, height: 70.0)

        }
        
        oceanObjectNode.zPosition = ZPositions.oceanObject
        
        super.init(texture: nil, color: UIColor.clear, size: oceanObjectSize)
        
        addChild(oceanObjectNode)
        
        physicsBody = SKPhysicsBody()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
