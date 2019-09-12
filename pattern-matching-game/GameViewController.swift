//
//  GameViewController.swift
//  pattern-matching-game
//
//  Created by Joshua Kuan on 9/11/19.
//  Copyright © 2019 Joshua Kuan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var gameView: SKView!
    var items: Items!
    var scene: GameScene!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .init(red: 0.149, green: 0.149, blue: 0.149, alpha: 1.0)
        
        gameView.showsFPS = true
        gameView.showsNodeCount = true
        gameView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        gameView.presentScene(scene)

    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
