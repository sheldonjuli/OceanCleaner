//
//  SKNodeExtensions.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-25.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import SpriteKit

extension SKNode {

    func aspectScale(to size: CGSize, regardingWidth: Bool, multiplier: CGFloat) {
        let scale = regardingWidth ? (size.width * multiplier) / self.frame.size.width : (size.height * multiplier) / self.frame.size.height
        self.setScale(scale)
    }

}
