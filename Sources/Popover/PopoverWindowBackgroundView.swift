//
//  PopoverWindowBackgroundView.swift
//  Popover
//
//  Created by Ivan Sapozhnik on 29.03.20.
//

import Cocoa

class PopoverWindowBackgroundView: NSView {
    private let wConfig: PopoverConfiguration

    private var visualEffect: NSVisualEffectView?
    
    var arrowXLocation: CGFloat = 0.0 {
        didSet {
            needsDisplay = true
        }
    }

    init(frame frameRect: NSRect, windowConfiguration: PopoverConfiguration) {
        self.wConfig = windowConfiguration
        super.init(frame: frameRect)

//        setupVisualEffect()
    }

    private func setupVisualEffect() {
        let visualEffect = NSVisualEffectView()
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.appearance = NSAppearance.current
        guard let appearence = NSAppearance.current else { return }
        switch appearence.name {
        case .aqua:
            visualEffect.material = .dark
        case .darkAqua:
            visualEffect.material = .dark
        default:
            break
        }

        self.visualEffect = visualEffect

        addSubview(visualEffect)

        NSLayoutConstraint.activate([
            visualEffect.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            visualEffect.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            visualEffect.topAnchor.constraint(equalTo: self.topAnchor),
            visualEffect.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var borderWidth: CGFloat {
        return wConfig.borderColor != nil ? wConfig.borderWidth : 0
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.

        let backgroundRect = NSMakeRect(NSMinX(bounds), NSMinY(bounds), NSWidth(bounds), NSHeight(bounds) - wConfig.arrowHeight).insetBy(dx: borderWidth, dy: borderWidth)

        let controlPoints = NSBezierPath()
        let windowPath = NSBezierPath()
        let arrowPath = NSBezierPath()
        let backgroundPath = NSBezierPath(roundedRect: backgroundRect, xRadius: wConfig.cornerRadius, yRadius: wConfig.cornerRadius)

        let x = arrowXLocation
        let leftPoint = NSPoint(x: x - wConfig.arrowWidth / 2, y: NSMaxY(backgroundRect))
        let toPoint = NSPoint(x: x, y: NSMaxY(backgroundRect) + wConfig.arrowHeight)
        let rightPoint = NSPoint(x: x + wConfig.arrowWidth / 2, y: NSMaxY(backgroundRect))
        let cp11 = NSPoint(x: x - wConfig.arrowWidth / 6, y: NSMaxY(backgroundRect))
        let cp12 = NSPoint(x: x - wConfig.arrowWidth / 9, y: NSMaxY(backgroundRect) + wConfig.arrowHeight)
        let cp21 = NSPoint(x: x + wConfig.arrowWidth / 9, y: NSMaxY(backgroundRect) + wConfig.arrowHeight)
        let cp22 = NSPoint(x: x + wConfig.arrowWidth / 6, y: NSMaxY(backgroundRect))

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

        if let lineColor = wConfig.borderColor {
            lineColor.setStroke()
            windowPath.lineWidth = wConfig.borderWidth
            windowPath.stroke()
        }

        wConfig.backgroundColor.setFill()
        windowPath.fill()

        let antialiasingMask: CAEdgeAntialiasingMask = [.layerLeftEdge, .layerRightEdge, .layerBottomEdge, .layerTopEdge]
        let mask = CAShapeLayer()
        mask.edgeAntialiasingMask = antialiasingMask
        mask.path = windowPath.cgPath
        visualEffect?.layer?.mask = mask


//        NSColor.red.setFill()
//        controlPoints.fill()
    }
    
    override var frame: NSRect {
        didSet {
            setNeedsDisplay(frame)
        }
    }
}

extension NSBezierPath {
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)

            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                break
            }
        }
        return path
    }
}
