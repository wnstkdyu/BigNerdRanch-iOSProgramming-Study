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
    var selectedLineIndex: Int? {
        didSet {
            guard selectedLineIndex == nil else { return }
            UIMenuController.shared.setMenuVisible(false, animated: true)
        }
    }
    var panGestureRecognizer: UIPanGestureRecognizer?
    
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
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveLine(_:)))
        panGestureRecognizer?.delegate = self
        panGestureRecognizer?.cancelsTouchesInView = false
        guard let panGestureRecognizer = panGestureRecognizer else { return }
        addGestureRecognizer(panGestureRecognizer)
    }
    
    // MARK: Draw
    override func draw(_ rect: CGRect) {
        finishedLineColor.setStroke()
        for line in finishedLines {
            stroke(line)
        }
        
        for line in currentLines.values {
            line.angle.color.setStroke()
            stroke(line)
        }
        
        guard let index = selectedLineIndex else { return }
        UIColor.green.setStroke()
        let selectedLine = finishedLines[index]
        stroke(selectedLine)
    }
    
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineCapStyle = .round
        path.lineWidth = lineThickness
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    // MARK: GestureRecognizer Selector
    @objc func doubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        print("Recognized a double tap")
        
        selectedLineIndex = nil
        currentLines.removeAll()
        finishedLines.removeAll()
        setNeedsDisplay()
    }
    
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        print("Recognized a tap")
        
        let touchLocation = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: touchLocation)
        
        let menuController = UIMenuController.shared
        if selectedLineIndex != nil {
            becomeFirstResponder()
            
            let deleteMenuItem = UIMenuItem(title: "Delete", action: #selector(deleteLine(_:)))
            menuController.menuItems = [deleteMenuItem]
            
            let menuControllerFrame = CGRect(x: touchLocation.x, y: touchLocation.y, width: 2, height: 2)
            menuController.setTargetRect(menuControllerFrame, in: self)
            menuController.setMenuVisible(true, animated: true)
        } else {
            menuController.setMenuVisible(false, animated: true)
        }
        
        setNeedsDisplay()
    }
    
    @objc func longPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        print("Recognized a long press")
        
        switch gestureRecognizer.state {
        case .began:
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLine(at: point)
            
            if selectedLineIndex != nil {
                currentLines.removeAll()
            }
        case .ended:
            selectedLineIndex = nil
        default:
            break
        }
        
        setNeedsDisplay()
    }
    
    @objc func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let index = selectedLineIndex else { return }
        print("Recognized a pan")
        
        if gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self)
            
            finishedLines[index].begin.x += translation.x
            finishedLines[index].begin.y += translation.y
            finishedLines[index].end.x += translation.x
            finishedLines[index].end.y += translation.y
            
            gestureRecognizer.setTranslation(.zero, in: self)
            
            let velocity = gestureRecognizer.velocity(in: self)
            if velocity.x > 0 {
                lineThickness = 30
            } else {
                lineThickness = 10
            }
            
            setNeedsDisplay()
        }
    }
    
    func indexOfLine(at point: CGPoint) -> Int? {
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        
        return nil
    }
    
    @objc func deleteLine(_ sender: UIMenuController) {
        guard let index = selectedLineIndex else { return }
        
        finishedLines.remove(at: index)
        selectedLineIndex = nil
        
        setNeedsDisplay()
    }
}

extension DrawView {
    // MARK: UIResponder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        selectedLineIndex = nil
        
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
}

extension DrawView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension CGFloat {
    var color: UIColor {
        if self <= 0 {
            return .red
        } else {
            return .yellow
        }
    }
}
