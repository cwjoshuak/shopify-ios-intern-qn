//
//  GameScene.swift
//  pattern-matching-game
//
//  Created by Joshua Kuan on 9/11/19.
//  Copyright © 2019 Joshua Kuan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var rows: CGFloat = 6.0
    var cols: CGFloat = 5.0
    var matchedPatterns: Int = 2
    var textures: [String:[SKTexture]]!
    
    init(size: CGSize, rows: Int, cols: Int, matchedPatterns: Int, textures: [String:[SKTexture]]) {
        super.init(size: size)
        self.rows = CGFloat(rows)
        self.cols = CGFloat(cols)
        self.matchedPatterns = matchedPatterns
        self.textures = textures
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        // on initial vc show, initialize grid
        let bounds = view.bounds.size
        let width = (bounds.width  - (cols)) / cols
        let height = (bounds.height - (rows)) / (rows+0.5)
        if let grid = Grid(width: width, height: height, rows: Int(rows), cols: Int(cols)) {
            grid.position = CGPoint (x:frame.midX, y:frame.midY)
            addChild(grid)
            
            initializeGrid(grid)
            
            Timer.scheduledTimer(withTimeInterval: 1.34, repeats: true) { (timer) in
                NotificationCenter.default.post(name: .init("updateStartingLabel"), object: timer)
            }
            // hide sprites after 4 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                grid.children.forEach { (node) in
                    node.run(SKAction.fadeOut(withDuration: 0.4))
                }
            }
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func initializeGrid(_ grid: Grid) {
        var selectedTextures = [SKTexture]()
        for _ in 0..<(Int(rows * cols) / matchedPatterns){
            let elem = textures.randomElement()!
            for _ in 0..<matchedPatterns { selectedTextures.append(elem.value.randomElement()!) }
        }
        
        for row in 0..<grid.rows {
            for col in 0..<grid.cols {
                let index = row + (row * Int(cols-1)) + col
                let gamePiece = SKSpriteNode(texture: selectedTextures[index])
                gamePiece.name = textures.filter({ (key: String, value: [SKTexture]) -> Bool in
                    value.contains(selectedTextures[index])
                    }).first?.key
                gamePiece.setScale(0.38 * 12 / CGFloat(grid.cols * grid.rows))
                gamePiece.zPosition = grid.zPosition+1
                gamePiece.position = grid.gridPosition(row: row, col: col)
                grid.addChild(gamePiece)
                
            }
        }
        grid.shuffleGrid()
        
    }
    
}
