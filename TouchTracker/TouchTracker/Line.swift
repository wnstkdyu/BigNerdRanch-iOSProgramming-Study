//
//  Line.swift
//  TouchTracker
//
//  Created by Alpaca on 2018. 7. 10..
//  Copyright © 2018년 Alpaca. All rights reserved.
//

import Foundation
import CoreGraphics

struct Line {
    
    var begin = CGPoint.zero
    var end = CGPoint.zero
    var angle: CGFloat = 0
    
    init(begin: CGPoint, end: CGPoint) {
        self.begin = begin
        self.end = end
    }
}
