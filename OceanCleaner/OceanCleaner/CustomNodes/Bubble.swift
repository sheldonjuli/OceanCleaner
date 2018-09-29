//
//  Bubble.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-29.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit

enum BubbleLayer {
    case one, two, three
}

struct BubbleColor {
    static let DarkBlue = "172E50"
    static let MidBlue = "1689A6"
    static let LightBlue = ""
}

class Bubble: SKSpriteNode {
    
    // every bubble will be removed after x moves
    var lifeRemain = 20
    
    /**
     Initializes an Bubble object.
     
     - Parameter layer: used to match color to the background.
     */
    init(on layer: BubbleLayer) {
        
        lifeRemain = randomInt(from: 5, to: 20)
        
        var bubbleColor = UIColor.white
        
        switch layer {
        case .one:
            bubbleColor = UIColor(hex: BubbleColor.DarkBlue)
        case .two:
            bubbleColor = UIColor(hex: BubbleColor.MidBlue)
        case.three:
            bubbleColor = UIColor(hex: BubbleColor.LightBlue)
        }
        
        let bubble = SKShapeNode(circleOfRadius: 5.0)
        bubble.fillColor = bubbleColor
        bubble.strokeColor = UIColor.clear
        bubble.zPosition = ZPositions.oceanObject
        
        super.init(texture: nil, color: .clear, size: CGSize(width: 10, height: 10))
        
        addChild(bubble)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
