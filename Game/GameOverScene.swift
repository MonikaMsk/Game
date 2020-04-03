//
//  GameOverScene.swift
//  Game
//
//  Created by ITHS on 2020-04-03.
//  Copyright © 2020 ITHS. All rights reserved.
//

import SpriteKit
import FirebaseDatabase

class GameOver: SKScene {
    
    
   var playButton = SKSpriteNode()
   let playButtonTex = SKTexture(imageNamed: "Play")

  
    var scoreLabel:SKLabelNode!
    var score:Int = 0

    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        self.addChild(playButton)
        
        
        //score label
        scoreLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-Bold")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.color = SKColor.white
        scoreLabel.fontSize = CGFloat(integerLiteral:40)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(scoreLabel)
        
      print(score)
        
        
        let ref = Database.database().reference()
        ref.childByAutoId().setValue(["high-score": score])
        
        
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



