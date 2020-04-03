//
//  WindowConfiguration.swift
//  Popover
//
//  Created by Ivan Sapozhnik on 29.03.20.
//  Copyright © 2020 heavylightapps. All rights reserved.
//

import Cocoa

public protocol PopoverConfiguration {
    var popoverToStatusItemMargin: CGFloat { get }
    var backgroundColor: NSColor { get }
    var borderColor: NSColor? { get }
    var borderWidth: CGFloat { get }
    var arrowHeight: CGFloat { get }
    var arrowWidth: CGFloat { get }
    var cornerRadius: CGFloat { get }
    var contentInset: NSEdgeInsets { get }
}

open class DefaultConfiguration: PopoverConfiguration {
    public init() {}
    
    open var popoverToStatusItemMargin: CGFloat {
        return 2
    }

    open var backgroundColor: NSColor {
        return NSColor.windowBackgroundColor
    }

    open var borderColor: NSColor? {
        return NSColor.white
    }

    open var borderWidth: CGFloat {
        return 2
    }

    open var arrowHeight: CGFloat {
        return 12.0
    }

    open var arrowWidth: CGFloat {
        return 62.0
    }

    open var cornerRadius: CGFloat {
        return 12
    }

    open var contentInset: NSEdgeInsets {
        return NSEdgeInsetsZero
    }
}
