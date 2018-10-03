//
//  SKActionExtensions.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-10-03.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit

extension SKAction {
    
    func rotateLeftAndRightForever(by angle: CGFloat, duration: TimeInterval) -> SKAction {
        let rotateLeft = SKAction.rotate(byAngle: -angle, duration: duration)
        let rotateRight = SKAction.rotate(byAngle: angle, duration: duration)
        return SKAction.repeatForever(SKAction.sequence([
            rotateLeft,
            rotateLeft.reversed(),
            rotateRight,
            rotateRight.reversed()
            ]))
    }
    
}
