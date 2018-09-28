//
//  SpriteKitButton.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-25.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit

/**
 A SKSpriteNode which functions as a button.
 */
class SpriteKitButton: SKSpriteNode {
    
    var spriteKitButton: SKSpriteNode
    var action: (Int) -> ()
    var caseId: Int
    
    /**
     Initializes a SpriteKitButton.
     
     - Parameter buttonImage: The name of the button image.
     - Parameter action: Action to perform when button is pressed.
     - Parameter caseId: An integer to indicate which case the action should perform.
     */
    init(buttonImage: String, action: @escaping (Int) -> (), caseId: Int) {
        spriteKitButton = SKSpriteNode(imageNamed: buttonImage)
        self.action = action
        self.caseId = caseId
        
        super.init(texture: nil, color: UIColor.clear, size: spriteKitButton.size)
        
        isUserInteractionEnabled = true
        addChild(spriteKitButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Button pressed animation
        spriteKitButton.alpha = 0.75
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.location(in: self)
        
        if spriteKitButton.contains(location) {
            spriteKitButton.alpha = 0.75
        } else {
            spriteKitButton.alpha = 1.0
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.location(in: self)
        
        if spriteKitButton.contains(location) {
            action(caseId)
        }
        
        spriteKitButton.alpha = 1.0
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        spriteKitButton.alpha = 1.0
    }
    
}
