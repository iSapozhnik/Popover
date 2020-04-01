//
//  PopoverWindowController.swift
//  Popover
//
//  Created by Ivan Sapozhnik on 29.03.20.
//  Copyright © 2020 heavylightapps. All rights reserved.
//

import Cocoa

class PopoverWindowController: NSWindowController {
    public private(set) var windowIsOpen: Bool = false
    public private(set) var isAnimating: Bool = false

    private let popover: Popover
    private let windowConfiguration: PopoverConfiguration

    init(with popover: Popover, contentViewController: NSViewController, windowConfiguration: PopoverConfiguration) {
        self.popover = popover
        self.windowConfiguration = windowConfiguration

        super.init(window: PopoverWindow.window(with: windowConfiguration))
        self.contentViewController = contentViewController
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func show() {
        guard !isAnimating else { return }

        updateWindwFrame()
        window?.alphaValue = 1.0
        showWindow(nil)
        windowIsOpen = true
        window?.makeKey()
        // TODO: animation
    }

    public func dismiss() {
        guard !isAnimating else { return }

        window?.orderOut(self)
        window?.close()
        windowIsOpen = false
    }

    private func updateWindwFrame() {
        guard let popoverRect = popover.item.button?.window?.frame, let window = window else { return }
        let x = NSMinX(popoverRect) - NSWidth(window.frame)/2 + NSWidth(popoverRect)/2 + windowConfiguration.lineWidth
        let y = min(NSMinY(popoverRect), NSScreen.main!.frame.size.height - NSHeight(window.frame) - windowConfiguration.windowToPopoverMargin)

        let windowFrame = NSMakeRect(x, y, NSWidth(window.frame), NSHeight(window.frame))
        window.setFrame(windowFrame, display: true)
        window.appearance = NSAppearance.current
    }

}
