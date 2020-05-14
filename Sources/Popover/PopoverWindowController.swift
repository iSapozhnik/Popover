//
//  PopoverWindowController.swift
//  Popover
//
//  Created by Ivan Sapozhnik on 29.03.20.
//

import Cocoa

class PopoverWindowController: NSWindowController, NSWindowDelegate {
    public private(set) var windowIsOpen: Bool = false
    public private(set) var isAnimating: Bool = false

    private let popover: Popover
    private let wConfig: PopoverConfiguration

    init(with popover: Popover, contentViewController: NSViewController, windowConfiguration: PopoverConfiguration) {
        self.popover = popover
        self.wConfig = windowConfiguration

        let window = PopoverWindow.window(with: windowConfiguration)
        super.init(window: window)
        window.delegate = self
        self.contentViewController = contentViewController
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        guard !isAnimating else { return }

        updateWindowFrame()

        showWindow(nil)
        windowIsOpen = true
        window?.makeKey()
        // TODO: animation
    }

    func dismiss() {
        guard !isAnimating else { return }

        window?.orderOut(self)
        window?.close()
        windowIsOpen = false
    }

    func updateWindowFrame() {
        guard let window = self.window as? PopoverWindow else { return }
        let windowFrame = visibleStatusItemWindowFrame()
        window.arrowXLocation = windowFrame.arrowXLocation
        window.setFrame(windowFrame.frame, display: true)
        window.appearance = NSAppearance.current
    }

    private func visibleStatusItemWindowFrame() -> (frame: NSRect, arrowXLocation: CGFloat) {
        let screenFrame = currentMouseScreen().frame
        let statusItemRect = popover.item.button?.window?.frame ?? .zero

        guard let window = self.window else { return (.zero, 0.0) }

        let borderWidth = wConfig.borderColor != nil ? wConfig.borderWidth : 0
        let x = min(NSMinX(statusItemRect) - NSWidth(window.frame) / 2 + NSWidth(statusItemRect) / 2 + borderWidth, NSMaxX(screenFrame) - NSWidth(window.frame) - wConfig.rightEdgeMargin)
        let y = min(NSMinY(statusItemRect), NSMaxY(screenFrame)) - NSHeight(window.frame) - wConfig.popoverToStatusItemMargin + borderWidth / 2

        let windowFrame = NSMakeRect(x, y, NSWidth(window.frame), NSHeight(window.frame))

        let arrowXLocation = NSMinX(statusItemRect) + NSWidth(statusItemRect) / 2 - NSMinX(windowFrame)

        return (windowFrame, arrowXLocation)
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

    func windowDidResize(_ notification: Notification) {
        updateWindowFrame()
    }
}
