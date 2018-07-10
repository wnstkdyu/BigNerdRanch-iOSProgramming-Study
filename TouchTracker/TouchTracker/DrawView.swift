//
//  DrawView.swift
//  TouchTracker
//
//  Created by Alpaca on 2018. 7. 10..
//  Copyright © 2018년 Alpaca. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var currentLines: [NSValue: Line] = [:]
    var finishedLines: [Line] = []
    
    @IBInspectable var finishedLineColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var currentLineColor: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: UIResponder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            let location = touch.location(in: self)
            let newLine = Line(begin: location, end: location)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines.updateValue(newLine, forKey: key)
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
            
            guard var line = currentLines[key] else { continue }
            line.end = touch.location(in: self)

            let begin = line.begin
            let end = line.end

            let angle = (end.y - begin.y) / (end.x - begin.x)
            currentLines[key]?.angle = angle
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        currentLines.removeAll()
        
        setNeedsDisplay()
    }
    
    // MARK: Draw
    override func draw(_ rect: CGRect) {
        finishedLineColor.setStroke()
        if finishedLines.count == 2 {
            let line1End = finishedLines[0].end
            let line2End = finishedLines[1].end
            strokeCircle(line1End, line2End)
            finishedLines.removeAll()
        }
        
        for line in currentLines.values {
            stroke(line)
        }
    }
    
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineCapStyle = .round
        path.lineWidth = lineThickness
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    func strokeCircle(_ line1End: CGPoint, _ line2End: CGPoint) {
        let arcCenter = CGPoint(x: (line1End.x + line2End.x) / 2, y: (line1End.y + line2End.y) / 2)
        let radius = sqrt(pow((line1End.x - line2End.x), 2) + pow((line1End.y - line2End.y), 2)) / 2 - lineThickness
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let circleLayer: CAShapeLayer = {
            let circleLayer = CAShapeLayer()
            circleLayer.path = circlePath.cgPath
            circleLayer.lineWidth = lineThickness
            circleLayer.strokeColor = UIColor.black.cgColor
            circleLayer.fillColor = UIColor.clear.cgColor
            
            return circleLayer
        }()
        
        layer.addSublayer(circleLayer)
    }
}

extension CGFloat {
    var color: UIColor {
        if self <= 0 {
            return .green
        } else {
            return .yellow
        }
    }
}
