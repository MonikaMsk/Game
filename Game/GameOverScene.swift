//
//  GameOverScene.swift
//  Game
//
//  Created by ITHS on 2020-04-03.
//  Copyright © 2020 ITHS. All rights reserved.
//

import Foundation
import SpriteKit

class GameOver: SKScene {
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0

    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.
        
        scoreLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-Bold")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.color = SKColor.white
        scoreLabel.fontSize = CGFloat(integerLiteral:40)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(scoreLabel)
        
      print(score)
        
    }
    
    
    
}



