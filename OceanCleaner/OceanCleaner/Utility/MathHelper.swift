//
//  MathHelper.swift
//  OceanCleaner
//
//  Created by Li Ju on 2018-09-27.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import UIKit

/**
 A helper function to generate a random CGFlost within the given range.
 
 - Parameter lowerLimit: The lower limit.
 - Parameter upperLimit: The upper limit.
 
 - Returns: The generated random number.
 */
func randomCGFloat(from lowerLimit: CGFloat, to upperLimit: CGFloat) -> CGFloat {
    
    return lowerLimit + CGFloat(arc4random()) / CGFloat(UInt32.max) * (upperLimit - lowerLimit)
    
}

/**
 A helper function to generate a random Int within the given range.
 
 - Parameter lowerLimit: The lower limit.
 - Parameter upperLimit: The upper limit.
 
 - Returns: The generated random number.
 */
func randomInt(from lowerLimit: Int, to upperLimit: Int) -> Int {
    
    return lowerLimit + Int(arc4random_uniform(UInt32(upperLimit - lowerLimit + 1)))
    
}
