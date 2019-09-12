//
//  Grid.swift
//  pattern-matching-game
//
//  Created by Joshua Kuan on 9/11/19.
//  Copyright © 2019 Joshua Kuan. All rights reserved.
//

import UIKit
import SpriteKit

class Grid: SKSpriteNode {
    var rows:Int!
    var cols:Int!
    var width:CGFloat!
    var height:CGFloat!
    var selectedNodes = [SKNode]()
    var hidingTimer: Timer?
    convenience init?(width:CGFloat, height:CGFloat, rows:Int, cols:Int) {
        guard let texture = Grid.gridTexture(width: width, height: height, rows: rows, cols: cols) else {
            return nil
        }
        self.init(texture: texture, color:SKColor.clear, size: texture.size())
        self.width = width
        self.height = height
        self.rows = rows
        self.cols = cols
        self.isUserInteractionEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(shuffleGrid), name: NSNotification.Name(rawValue: "shuffleGrid"), object: nil)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        hideSelectedNodes(animated: false)
        
        for touch in touches {
            let position = touch.location(in:self)
            
            self.children.forEach { (node) in
                if node.contains(position) {
                    if node.alpha == 0 {
                        node.run(SKAction.fadeIn(withDuration: 0.15))
                        selectedNodes.append(node)
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
                            timer.invalidate()
                            self.hideSelectedNodes(animated: true)
                        }
                    } else {
                        node.run(SKAction.rotate(byAngle: CGFloat.pi*2, duration: 1))
                    }
                }
            }
        }
        
    }
    func checkGameEnd() {
        if self.children.allSatisfy({ $0.alpha == 1.0 }) {
            NotificationCenter.default.post(name: .init("endGame"), object: nil)
        }
    }
    func hideSelectedNodes(animated: Bool) {
        hidingTimer?.invalidate()
        if selectedNodes.count >= 2 {
            if self.selectedNodes[0].name != self.selectedNodes[1].name {
                self.selectedNodes.forEach { (sNode) in
                    if animated {
                        sNode.run(SKAction.fadeOut(withDuration: 0.1))
                    } else {
                        sNode.run(SKAction.fadeOut(withDuration: 0.0))
                    }
                }
                NotificationCenter.default.post(name: .init("incrementFails"), object: nil)
            } else {
                NotificationCenter.default.post(name: .init("incrementSuccess"), object: nil)
            }
            selectedNodes = [SKNode]()
        }
        checkGameEnd()
    }
    class func gridTexture(width:CGFloat, height:CGFloat,rows:Int,cols:Int) -> SKTexture? {
        
        let size = CGSize(width: CGFloat(cols)*width+1.0, height: CGFloat(rows)*height+1.0)
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setFillColor(UIColor(patternImage: UIImage(named: "bg_blank")!).cgColor)
            
        context.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let bezierPath = UIBezierPath()
        let offset:CGFloat = 0.5
        // Draw vertical lines
        for i in 0...cols {
            let x = CGFloat(i)*width + offset
            bezierPath.move(to: CGPoint(x: x, y: 0))
            bezierPath.addLine(to: CGPoint(x: x, y: size.height))
        }
        // Draw horizontal lines
        for i in 0...rows {
            let y = CGFloat(i)*height + offset
            bezierPath.move(to: CGPoint(x: 0, y: y))
            bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        }
        SKColor.white.setStroke()
        bezierPath.lineWidth = 1.0
        bezierPath.stroke()
        context.addPath(bezierPath.cgPath)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image!)
    }

    func gridPosition(row:Int, col:Int) -> CGPoint {
        let widthOffset = width / 2.0 + 0.5
        let heightOffset = height / 2.0 + 1.5
        let x = CGFloat(col) * width - (width * CGFloat(cols)) / 2.0 + widthOffset
        let y = CGFloat(rows - row - 1) * height - (height * CGFloat(rows)) / 2.0 + heightOffset
        return CGPoint(x:x, y:y)
    }
    
    @objc func shuffleGrid() {
        var tupleArray = [(Int, Int)]()
        for r in 0..<rows {
            for c in 0..<cols {
                tupleArray.append((r,c))
            }
        }
        tupleArray.shuffle()
        var sum = 0
        self.children.forEach { (node) in
            node.run(SKAction.move(to: gridPosition(row: tupleArray[sum].0, col: tupleArray[sum].1), duration: 0.3))
            sum += 1
        }
    }
}
