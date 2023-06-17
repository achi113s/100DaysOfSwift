//
//  K.swift
//  Project23SwiftyNinja
//
//  Created by Giorgio Latour on 6/17/23.
//

import Foundation

struct K {
    // Minimum and maximum x and y velocities for enemies.
    static let minXSpeedFast: Int = 8
    static let maxXSpeedFast: Int = 15
    static let minXSpeedSlow: Int = 3
    static let maxXSpeedSlow: Int = 5
    
    static let minYSpeed: Int = 24
    static let maxYSpeed: Int = 32
    
    static let minAngularSpeed: Int = -3
    static let maxAngularSpeed: Int = 3
    
    static let speedMultiplier: Int = 40
    
    static let offScreenYPosition: Int = -128
    
    // Constants which control how quickly the game difficulty increases.
    static let popupTimeMultiplier: Double = 0.991
    static let chainDelayMultiplier: Double = 0.99
    static let physicsWorldSpeedMultiplier: Double = 1.02
    
    
    // Constants for chain creation.
    static let normalChainMultiplier: Double = 5.0
    static let fastChainMultiplier: Double = 10.0
}
