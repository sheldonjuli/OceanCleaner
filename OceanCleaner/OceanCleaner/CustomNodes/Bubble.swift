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
    static let LightBlue = "42D8B2"
    static let DarkBlue = "172E50"
    static let MidBlue = "1689A6"
}

class Bubble: SKSpriteNode {
    
    // every bubble will be removed after x moves
    var lifeRemain = 20
    
    /**
     Initializes an Bubble object.
     
     - Parameter layer: used to match color to the background.
     */
    init(in view: SKView, on layer: BubbleLayer) {
        
        lifeRemain = randomInt(from: 5, to: 15)
        
        var bubbleColor = UIColor.white
        
        switch layer {
        case .one:
            bubbleColor = UIColor(hex: BubbleColor.LightBlue)
        case .two:
            bubbleColor = UIColor(hex: BubbleColor.DarkBlue)
        case.three:
            bubbleColor = UIColor(hex: BubbleColor.MidBlue)
        }
        
        let radius = view.bounds.width * 0.01
        let bubble = SKShapeNode(circleOfRadius: radius)
        bubble.fillColor = bubbleColor
        bubble.strokeColor = UIColor.clear
        bubble.alpha = 0.25
        bubble.zPosition = ZPositions.oceanObject
        
        super.init(texture: nil, color: .clear, size: CGSize(width: 2 * radius, height: 2 * radius))
        
        addChild(bubble)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
