//
//  WindowConfiguration.swift
//  Popover
//
//  Created by Ivan Sapozhnik on 29.03.20.
//

import Cocoa

public protocol PopoverConfiguration {
    /// The distance from Popover's arrow to a status item.
    var popoverToStatusItemMargin:  CGFloat { get }

    /// Popover's background color.
    var backgroundColor:            NSColor { get }

    /// Popover's border color.
    /// - Important:
    ///     If `borderColor` returns `nil`, settings `borderWidth` won't make any effect. See also: `borderWidth`.
    var borderColor:                NSColor? { get }

    /// Popover's border width.
    /// - Important:
    ///      If Popover's border color is set to `nil`, setting `borderWidth` won't make any effect.
    var borderWidth:                CGFloat { get }

    /// Defines Popover arrow height.
    var arrowHeight:                CGFloat { get }

    /// Defines Popover arrow width.
    var arrowWidth:                 CGFloat { get }

    /// Defines Popover corner radius.
    /// - Warning:
    ///     If this value is too big and if the Popover's status item (menu bar view) is too close to the right edge, the appearence of the Popover might be odd.
    var cornerRadius:               CGFloat { get }

    /// Defines Popover content edge insets.
    var contentEdgeInsets:          NSEdgeInsets { get }

    /// The distance from the right side of the Popover to the screen's edge.
    /// - Warning:
    ///     If this value is too big and if the Popover's status item (menu bar view) is too close to the right edge, the appearence of the Popover might be odd.
    var rightEdgeMargin:            CGFloat { get }
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
        return 5
    }

    open var contentEdgeInsets: NSEdgeInsets {
        return NSEdgeInsetsZero
    }

    open var rightEdgeMargin: CGFloat {
        return 12.0
    }
}
