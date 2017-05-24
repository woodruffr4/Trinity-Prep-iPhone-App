//
//  NavBarButton.swift
//  TrinityPrep
//
//  Created by Ricky Woodruff on 1/22/17.
//  Copyright © 2017 Ricky Woodruff. All rights reserved.
//

import UIKit

class NavBarButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        
        // thickness of your line
        let lineThick:CGFloat = 1.0
        
        // length of your line relative to your button
        let lineLenght:CGFloat = min(bounds.width, bounds.height) * 0.8
        
        // color of your line
        let lineColor: UIColor = UIColor.white
        
        // this will add small padding from button border to your first line and other lines
        let marginGap: CGFloat = 10.0
        
        // we need three line
        for line in 0...2 {
            // create path
            let linePath = UIBezierPath()
            //linePath.lineWidth = lineThick
            
            //start point of line
            linePath.move(to: CGPoint(
                x: bounds.width/2 - lineLenght/2,
                y: 6.0 * CGFloat(line) + marginGap
            ))
            
            //end point of line
            linePath.addLine(to: CGPoint(
                x: bounds.width/2 + lineLenght/2,
                y: 6.0 * CGFloat(line) + marginGap
            ))
            //set line color
            lineColor.setStroke()
            
            //draw the line
            linePath.stroke()
        }
        
        
    }
    
    
}
