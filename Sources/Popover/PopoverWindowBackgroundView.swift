//
//  PopoverWindowBackgroundView.swift
//  Popover
//
//  Created by Ivan Sapozhnik on 29.03.20.
//  Copyright © 2020 heavylightapps. All rights reserved.
//

import Cocoa

class PopoverWindowBackgroundView: NSView {
    private let windowConfiguration: PopoverConfiguration

    init(frame frameRect: NSRect, windowConfiguration: PopoverConfiguration) {
        self.windowConfiguration = windowConfiguration
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var lineWidth: CGFloat {
        return windowConfiguration.lineColor != nil ? windowConfiguration.lineWidth : 0
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.

        let backgroundRect = NSMakeRect(NSMinX(bounds), NSMinY(bounds), NSWidth(bounds), NSHeight(bounds) - windowConfiguration.arrowHeight).insetBy(dx: lineWidth, dy: lineWidth)

        let controlPoints = NSBezierPath()
        let windowPath = NSBezierPath()
        let arrowPath = NSBezierPath()
        let backgroundPath = NSBezierPath(roundedRect: backgroundRect, xRadius: windowConfiguration.cornerRadius, yRadius: windowConfiguration.cornerRadius)

        let leftPoint = NSPoint(x: NSWidth(backgroundRect) / 2 - windowConfiguration.arrowWidth / 2, y: NSMaxY(backgroundRect))
        let toPoint = NSPoint(x: NSWidth(backgroundRect) / 2, y: NSMaxY(backgroundRect) + windowConfiguration.arrowHeight)
        let rightPoint = NSPoint(x: NSWidth(backgroundRect) / 2 + windowConfiguration.arrowWidth / 2, y: NSMaxY(backgroundRect))
        let cp11 = NSPoint(x: NSWidth(backgroundRect) / 2 - windowConfiguration.arrowWidth / 6, y: NSMaxY(backgroundRect))
        let cp12 = NSPoint(x: NSWidth(backgroundRect) / 2 - windowConfiguration.arrowWidth / 9, y: NSMaxY(backgroundRect) + windowConfiguration.arrowHeight)
        let cp21 = NSPoint(x: NSWidth(backgroundRect) / 2 + windowConfiguration.arrowWidth / 9, y: NSMaxY(backgroundRect) + windowConfiguration.arrowHeight)
        let cp22 = NSPoint(x: NSWidth(backgroundRect) / 2 + windowConfiguration.arrowWidth / 6, y: NSMaxY(backgroundRect))

        controlPoints.append(NSBezierPath(ovalIn: NSMakeRect(leftPoint.x - 2, leftPoint.y - 2, 4, 4)))
        controlPoints.append(NSBezierPath(ovalIn: NSMakeRect(toPoint.x - 2, toPoint.y - 2, 4, 4)))
        controlPoints.append(NSBezierPath(ovalIn: NSMakeRect(rightPoint.x - 2, rightPoint.y - 2, 4, 4)))
        controlPoints.append(NSBezierPath(ovalIn: NSMakeRect(cp11.x - 2, cp11.y - 2, 4, 4)))
        controlPoints.append(NSBezierPath(ovalIn: NSMakeRect(cp12.x - 2, cp12.y - 2, 4, 4)))
        controlPoints.append(NSBezierPath(ovalIn: NSMakeRect(cp21.x - 2, cp21.y - 2, 4, 4)))
        controlPoints.append(NSBezierPath(ovalIn: NSMakeRect(cp22.x - 2, cp22.y - 2, 4, 4)))

        arrowPath.move(to: leftPoint)
        arrowPath.curve(to: toPoint, controlPoint1: cp11, controlPoint2: cp12)
        arrowPath.curve(to: rightPoint, controlPoint1: cp21, controlPoint2: cp22)
        arrowPath.line(to: leftPoint)
        arrowPath.close()

        windowPath.append(arrowPath)
        windowPath.append(backgroundPath)

        if let lineColor = windowConfiguration.lineColor {
            lineColor.setStroke()
            windowPath.lineWidth = windowConfiguration.lineWidth
            windowPath.stroke()
        }


        windowConfiguration.backgroundColor.setFill()
        windowPath.fill()

//        controlPoints.fill()

    }
    
    override var frame: NSRect {
        didSet {
            setNeedsDisplay(frame)
        }
    }
}
