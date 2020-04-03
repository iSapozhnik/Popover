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
    private let wConfig: PopoverConfiguration

    init(with popover: Popover, contentViewController: NSViewController, windowConfiguration: PopoverConfiguration) {
        self.popover = popover
        self.wConfig = windowConfiguration

        super.init(window: PopoverWindow.window(with: windowConfiguration))
        self.contentViewController = contentViewController
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func show() {
        guard !isAnimating else { return }

        updateWindowFrame()
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

    private func updateWindowFrame() {
        let windowFrame = visibleStatusItemWindowFrame()
        window?.setFrame(windowFrame, display: true)
        window?.appearance = NSAppearance.current
    }

    private func visibleStatusItemWindowFrame() -> NSRect {
        let screenFrame = currentMouseScreen().frame
        let popoverRect = popover.item.button?.window?.frame ?? .zero

        guard let window = self.window else { return .zero }

        let borderWidth = wConfig.borderColor != nil ? wConfig.borderWidth : 0
        let x = NSMinX(popoverRect) - NSWidth(window.frame) / 2 + NSWidth(popoverRect) / 2 + borderWidth
        let y = min(NSMinY(popoverRect), NSMaxY(screenFrame)) - NSHeight(window.frame) - wConfig.popoverToStatusItemMargin + borderWidth / 2

        return NSMakeRect(
            x,
            y,
            NSWidth(window.frame),
            NSHeight(window.frame)
        )
    }

    private func currentMouseScreen() -> NSScreen {
        let currentMousePoint = NSEvent.mouseLocation
        var currentScreen: NSScreen?

        while currentScreen != nil {
            NSScreen.screens.forEach { screen in
                currentScreen = NSMouseInRect(currentMousePoint, screen.frame, false) ? screen : nil
            }
        }

        return currentScreen ?? NSScreen.main ?? NSScreen()
    }

}
