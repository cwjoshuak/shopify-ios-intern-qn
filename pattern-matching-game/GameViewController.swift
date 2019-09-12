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
    var rows: Int!
    var cols: Int!
    var patternMatches: Int!
    var textures: [String : [SKTexture]]!
    var readyCounter: Int = 3
    @IBOutlet weak var startingLabel: UILabel!
    var items: Items!
    var scene: GameScene!
    @IBOutlet weak var successCounter: UILabel!
    @IBOutlet weak var failedCounter: UILabel!
    
    @IBOutlet weak var matchesStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(incrementSuccess(notification:)), name: .init("incrementSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(incrementFails(notification:)), name: .init("incrementFails"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateStartingLabel(notification:)), name: .init("updateStartingLabel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endGame(notification:)), name: .init("endGame"), object: nil)
        
        scene = GameScene(size: gameView.frame.size, rows: rows, cols: cols, matchedPatterns: self.patternMatches, textures: self.textures)
        self.view.backgroundColor = .init(red: 0.149, green: 0.149, blue: 0.149, alpha: 1.0)
        gameView.showsFPS = false
        gameView.showsNodeCount = false
        gameView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        gameView.presentScene(scene)

    }
    @IBAction func shufflePress(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "shuffleGrid"), object: nil)
    }
    
    @IBAction func goBackHome(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    // MARK:- Utility functions
    // increment success matches counter
    @objc func incrementSuccess(notification: NSNotification) {
        successCounter.text = (Int(successCounter.text!)! + 1).description
    }
    // increment failed matches counter
    @objc func incrementFails(notification: NSNotification) {
        failedCounter.text = (Int(failedCounter.text!)! + 1).description
    }
    
    // ready set go!
    @objc func updateStartingLabel(notification: NSNotification) {
        if let timer = notification.object as? Timer {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2) {
                    switch self.readyCounter {
                        case 2:
                            self.startingLabel.text = "Get Set.."
                        case 1:
                            self.startingLabel.text = "Go!!"
                    case 0:
                        self.startingLabel.isHidden = true
                        self.matchesStackView.isHidden = false
                        timer.invalidate()
                    default:
                        return
                    }
                }
                self.readyCounter -= 1
            }
        }
    }
    @objc func endGame(notification: NSNotification) {
        if !startingLabel.isHidden { return }
        UIView.animate(withDuration: 0.3) {
            self.startingLabel.text = "Great Job! Play again?"
            self.startingLabel.isHidden = false
            self.matchesStackView.isHidden = true
        }
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
