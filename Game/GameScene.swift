//
//  GameScene.swift
//  Game
//
//  Created by ITHS on 2020-03-12.
//  Copyright © 2020 ITHS. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    private var player = SKSpriteNode()
    private var platform = SKSpriteNode()
    private var dimond = SKSpriteNode()
    
    //textures
    private var penguinWalking:[SKTexture] = []
    
    // Bitmask
    let playerCategory:UInt32 = 0x00000001 << 0
    let dimondCategory:UInt32 = 0x00000001 << 1
    let platformCategory:UInt32 = 0x00000001 << 2
    
     var isGamerOver =  false
    
    //counter
       lazy var countdownLabel: SKLabelNode = {
           var label = SKLabelNode(fontNamed: "AppleSDGothicNeo-Bold")
           label.fontSize = CGFloat(integerLiteral:40)
           label.color = SKColor.white
           label.verticalAlignmentMode = .center
           label.horizontalAlignmentMode = .right
           
           label.text = "\(counter)"
           return label
       }()
       
       var counter = 0
       var counterTimer = Timer()
       var counterStart = 30
    
    
    //score
      lazy var scoreLabel: SKLabelNode = {
          var label = SKLabelNode(fontNamed: "AppleSDGothicNeo-Bold")
          label.fontSize = CGFloat(integerLiteral:30)
          label.color = SKColor.white
          label.verticalAlignmentMode = .center
          label.horizontalAlignmentMode = .left
          label.text = "Score: 0"
          return label
      }()
      
   
      var score:Int = 0 {
          didSet{
              scoreLabel.text = "Score \(score)"
          }
      }
    
    

    

    override func didMove(to view: SKView) {
        setUpNodes()
        createPlayer()
        animatePenguin()
        moveEnded()
        createDimond()
        counter = counterStart
        startCounter()
       
        
        
        physicsWorld.contactDelegate = self
        
        //dimonds animation
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(createDimond),
                                                      SKAction.wait(forDuration: 1)])
        ))
        
        
        //score and timer
        countdownLabel.position = CGPoint(x: size.width * 0.9, y: size.height * 0.8)
               addChild(countdownLabel)
               scoreLabel.position = CGPoint(x:size.width * 0.1 , y:size.height * 0.8)
               addChild(scoreLabel)
               
        
        
    }
    
   
    
    //counter
    func startCounter(){
           counterTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decrementCounter), userInfo: nil, repeats: true)
           
       }
       
       @objc func decrementCounter(){
           
           if !isGamerOver{
               
               if counter <= 1{
                   isGamerOver = true
                   gameOver(won: false)
               }
               
               counter -= 1
               countdownLabel.text = "\(counter)"
           }
       }
    
    
    
    
     func gameOver(won:Bool){
          print("Game over!")
          removeAllActions()
          player.isHidden = true
         
      }
    
    
    
    func createPlayer(){
        let penguinAnimated = SKTextureAtlas(named:"Penguin")
        var walkFrames:[SKTexture] = []
        
        let numImg = penguinAnimated.textureNames.count
        for i in 1...numImg{
            let penguinTextureName = "penguin\(i)"
            walkFrames.append(penguinAnimated.textureNamed(penguinTextureName))
        }
        
        penguinWalking = walkFrames
        let firstTexture = penguinWalking[0]
        player = SKSpriteNode(texture:firstTexture)
        player.position = CGPoint(x:80, y:200)
        player.zPosition = 1
        addChild(player)
        
        //physics
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = dimondCategory
        player.physicsBody?.collisionBitMask = 0
        
        
    }
    
    
    func animatePenguin(){
        player.run(SKAction.repeatForever(SKAction.animate(with: penguinWalking, timePerFrame: 0.15,resize:false, restore: false)), withKey: "stationaryPenguin")
    }
    
    func moveEnded(){
        player.removeAllActions()
        platform.physicsBody?.categoryBitMask = platformCategory
        player.physicsBody?.collisionBitMask = platformCategory
        
    }
    
    func movePlayer(location:CGPoint){
        var multiplierDirection: CGFloat
        
        let playerSpeed = frame.size.width / 3.0
        
        let moveDifference = CGPoint(x:location.x - player.position.x, y: 0.0)
        let moveTo = sqrt(moveDifference.x * moveDifference.x)
        
        let moveDuration = moveTo / playerSpeed
        
        if moveDifference.x < 0 {
            multiplierDirection = -1.0
        } else {
            multiplierDirection = 1.0
        }
        player.xScale = abs(player.xScale) * multiplierDirection
        
        if player.action(forKey: "stationaryPenguin") == nil {
            animatePenguin()
        }
        
        let moveAction = SKAction.move(to: location, duration: (TimeInterval(moveDuration)))
        
        let doneAction = SKAction.run({[weak self] in self?.moveEnded()} )
        
        let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
        player.run(moveActionWithDone, withKey: "penguinMoving")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        movePlayer(location: location)
        
    }
    
    func createDimond(){
        dimond = SKSpriteNode(imageNamed: "Gem")
        let positionX = random(min: dimond.size.width / 2, max: size.width - dimond.size.width / 2)
        dimond.position = CGPoint(x: positionX, y: size.height + dimond.size.height / 2)
        dimond.physicsBody = SKPhysicsBody(rectangleOf: dimond.size)
        dimond.physicsBody?.isDynamic = true
        dimond.physicsBody?.categoryBitMask = dimondCategory
        dimond.physicsBody?.contactTestBitMask = playerCategory
        dimond.physicsBody?.collisionBitMask = 0
        dimond.physicsBody?.usesPreciseCollisionDetection = true
        dimond.zPosition = 1
        addChild(dimond)
        
        let duration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let action = SKAction.move(to: CGPoint(x: positionX, y: -dimond.size.height / 2), duration: TimeInterval(duration))
        
        let actionDone = SKAction.removeFromParent()
        dimond.run(SKAction.sequence([action,actionDone]))
        
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min:CGFloat, max:CGFloat) -> CGFloat{
        return random() * (max-min) + min
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collison: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
      
      if collison == dimondCategory | playerCategory{
          dimond.removeFromParent()
          score += 1
     
      }
    
      
      }
    
    
}












extension GameScene {
    
    func setUpNodes(){
        createPlatform()
        createBackground()
        createIgloo()
        createTree(at: CGPoint(x: 80, y: 50))
            createTree(at: CGPoint(x: 40, y: 30))
            createTree(at: CGPoint(x: 120, y: 30))
            createTree(at: CGPoint(x: 260, y: 30))
            createTree(at: CGPoint(x: 300, y: 50))
            createTree(at: CGPoint(x: 340, y: 50))
            createTree(at: CGPoint(x: 480, y: 50))
            createTree(at: CGPoint(x: 600, y: 30))
            createTree(at: CGPoint(x: 640, y: 50))
            createTree(at: CGPoint(x: 780, y: 50))
            createTree(at: CGPoint(x: 820, y: 30))
            
        }
    
    
    
    
    func createPlatform(){
        platform = SKSpriteNode (color: .systemTeal, size: CGSize(width: size.width, height: 20))
        platform.position = CGPoint(x: size.width / 2, y: 0.0)
        platform.physicsBody?.restitution = 0.75
        platform.zPosition = 1
        addChild(platform)
        
        //physics
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        
    }
    
    func createBackground(){
        let background = SKSpriteNode(imageNamed: "Background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -3.0
        addChild(background)
    }
    
    func createIgloo(){
           let igloo = SKSpriteNode(imageNamed: "igloo")
           igloo.position = CGPoint(x:550, y:50)
           igloo.zPosition = -2.0
           addChild(igloo)
       }
       
       func createTree(at position: CGPoint){
           
           let tree = SKSpriteNode(imageNamed: "Tree")
           tree.position = position
           tree.zPosition = -2.0
           addChild(tree)
       }
    
    
}
