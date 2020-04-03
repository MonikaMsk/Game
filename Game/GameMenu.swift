//
//  GameMenu.swift
//  Game
//
//  Created by ITHS on 2020-03-30.
//  Copyright © 2020 ITHS. All rights reserved.
//

import Foundation
import SpriteKit


class GameMenu: SKScene{
    
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "Play")
    var background = SKSpriteNode(imageNamed: "bg2")
    
    override func didMove(to view: SKView) {
        
        
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(playButton)
        background.zPosition = -1
        self.addChild(background)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                if let view = view {
                    let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}

