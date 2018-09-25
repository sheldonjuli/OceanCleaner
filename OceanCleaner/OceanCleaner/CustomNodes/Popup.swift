//
//  Popup.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-25.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit

protocol PopupButtonHandlerDelegate {
    func homeButtonTapped()
    func retryButtonTapped()
}

struct PopupButtons {
    static let home = 0
    static let retry = 1
}

class Popup: SKSpriteNode {
    
    var popupButtonHandlerDelegate: PopupButtonHandlerDelegate?
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.clear, size: size)
        setupPopup()
    }
    
    func setupPopup() {
        let background = SKSpriteNode(imageNamed: ImageNames.scoreSceneBackground)
        background.aspectScale(to: size, regardingWidth: true, multiplier: AspectScaleMultiplier.popup)
        
        let homeButton = SpriteKitButton(buttonImage: ImageNames.homeButton, action: popupButtonHandler, caseId: PopupButtons.home)
        let retryButton = SpriteKitButton(buttonImage: ImageNames.retryButton, action: popupButtonHandler, caseId: PopupButtons.retry)
        
        homeButton.aspectScale(to: background.size, regardingWidth: true, multiplier: AspectScaleMultiplier.homeButton)
        retryButton.aspectScale(to: background.size, regardingWidth: true, multiplier: AspectScaleMultiplier.retryButton)
        
        let buttonWidthOffset = retryButton.size.width / 2
        let buttonHeightOffset = retryButton.size.height / 2
        let backgroundWidthOffset = background.size.width / 2
        let backgroundHeightOffset = background.size.height / 2
        
        homeButton.position = CGPoint(x: -backgroundWidthOffset + buttonWidthOffset, y: -backgroundHeightOffset - buttonHeightOffset)
        retryButton.position = CGPoint(x: backgroundWidthOffset - buttonWidthOffset, y: -backgroundHeightOffset - buttonHeightOffset)
        background.position = CGPoint(x: 0, y: buttonHeightOffset)
        
        addChild(homeButton)
        addChild(retryButton)
        addChild(background)
    }
    
    func popupButtonHandler(index: Int) {
        switch index {
        case PopupButtons.home:
            popupButtonHandlerDelegate?.homeButtonTapped()
        case PopupButtons.retry:
            popupButtonHandlerDelegate?.retryButtonTapped()
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
