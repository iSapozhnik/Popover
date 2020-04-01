//
//  WindowConfiguration.swift
//  Popover
//
//  Created by Ivan Sapozhnik on 29.03.20.
//  Copyright © 2020 heavylightapps. All rights reserved.
//

import Cocoa

public protocol PopoverConfiguration {
    var windowToPopoverMargin: CGFloat { get }
    var backgroundColor: NSColor { get }
    var lineColor: NSColor? { get }
    var lineWidth: CGFloat { get }
    var arrowHeight: CGFloat { get }
    var arrowWidth: CGFloat { get }
    var cornerRadius: CGFloat { get }
    var contentInset: NSEdgeInsets { get }
}

public class DefaultConfiguration: PopoverConfiguration {
    public init() {}
    
    public var windowToPopoverMargin: CGFloat {
        return 22
    }

    public var backgroundColor: NSColor {
        return NSColor.windowBackgroundColor//NSColor(calibratedRed: 0.213, green: 0.213, blue: 0.213, alpha: 1.0)
    }

    public var lineColor: NSColor? {
        return nil//NSColor(calibratedRed: 0.413, green: 0.413, blue: 0.413, alpha: 1.0)
    }

    public var lineWidth: CGFloat {
        return lineColor != nil ? 6 : 0
    }

    public var arrowHeight: CGFloat {
        return 11.0
    }

    public var arrowWidth: CGFloat {
        return 62.0
    }

    public var cornerRadius: CGFloat {
        return 20.0
    }

    public var contentInset: NSEdgeInsets {
        return NSEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0)
    }
}
