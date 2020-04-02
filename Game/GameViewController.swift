//
//  GameViewController.swift
//  MyGame
//
//  Created by ITHS on 2020-03-09.
//  Copyright © 2020 ITHS. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = view as? SKView {
            
            let scene = GameMenu(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene)

            }

        }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    }

