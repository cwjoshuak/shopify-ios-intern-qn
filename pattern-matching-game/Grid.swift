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
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in:self)
            let node = atPoint(position)
            if node != self {
                let action = SKAction.rotate(byAngle: CGFloat.pi*2, duration: 1)
                node.run(action)
            }
            else {
                let x = size.width / 2 + position.x
                let y = size.height / 2 - position.y
                let row = Int(floor(x / width))
                let col = Int(floor(y / height))
                print("\(row) \(col)")
            }
        }
    }
    
    class func gridTexture(width:CGFloat, height:CGFloat,rows:Int,cols:Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
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
        let offset = width / 2.0 + 0.5
        let x = CGFloat(col) * width - (width * CGFloat(cols)) / 2.0 + offset
        let y = CGFloat(rows - row - 1) * height - (height * CGFloat(rows)) / 2.0 + offset
        return CGPoint(x:x, y:y)
    }
}
